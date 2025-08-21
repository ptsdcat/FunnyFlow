-- ==========================================================================================
-- Function: GetContentPopularity
-- Purpose:  Calculates the popularity score of content based on multiple factors such as
-- Views, likes, shares, comments, recency, and user engagement.
-- Returns a detailed breakdown and the final popularity score.
-- ==========================================================================================

CREATE OR ALTER FUNCTION dbo.GetContentPopularity
(
    @ContentId INT
)
RETURNS @PopularityDetails TABLE
(
    ContentId INT,
    Title NVARCHAR(255),
    Views INT,
    Likes INT,
    Shares INT,
    Comments INT,
    AvgSessionDuration FLOAT,
    UniqueViewers INT,
    RecencyScore FLOAT,
    EngagementScore FLOAT,
    ViralityScore FLOAT,
    FinalPopularityScore FLOAT,
    LastUpdated DATETIME
)
AS
BEGIN
    -- ===========================================
    -- 1. Fetch Content Basic Info
    -- ===========================================
    DECLARE @Title NVARCHAR(255)
    DECLARE @CreatedDate DATETIME
    DECLARE @LastUpdated DATETIME

    SELECT 
        @Title = c.Title,
        @CreatedDate = c.CreatedDate,
        @LastUpdated = c.LastUpdated
    FROM dbo.Content c
    WHERE c.ContentId = @ContentId

    -- ===========================================
    -- 2. Aggregate Engagement Metrics
    -- ===========================================
    DECLARE @Views INT = 0
    DECLARE @Likes INT = 0
    DECLARE @Shares INT = 0
    DECLARE @Comments INT = 0
    DECLARE @UniqueViewers INT = 0
    DECLARE @AvgSessionDuration FLOAT = 0

    -- Views
    SELECT @Views = COUNT(*) 
    FROM dbo.ContentViews
    WHERE ContentId = @ContentId

    -- Likes
    SELECT @Likes = COUNT(*) 
    FROM dbo.ContentLikes
    WHERE ContentId = @ContentId

    -- Shares
    SELECT @Shares = COUNT(*) 
    FROM dbo.ContentShares
    WHERE ContentId = @ContentId

    -- Comments
    SELECT @Comments = COUNT(*) 
    FROM dbo.ContentComments
    WHERE ContentId = @ContentId

    -- Unique Viewers
    SELECT @UniqueViewers = COUNT(DISTINCT UserId)
    FROM dbo.ContentViews
    WHERE ContentId = @ContentId

    -- Average Session Duration (in seconds)
    SELECT @AvgSessionDuration = ISNULL(AVG(SessionDuration), 0)
    FROM dbo.ContentViews
    WHERE ContentId = @ContentId

    -- ===========================================
    -- 3. Calculate Recency Score
    --    (More recent content gets a higher score)
    -- ===========================================
    DECLARE @DaysSinceCreated INT
    SET @DaysSinceCreated = DATEDIFF(DAY, @CreatedDate, GETDATE())

    DECLARE @RecencyScore FLOAT
    -- Exponential decay: newer content gets higher score
    SET @RecencyScore = EXP(-0.05 * @DaysSinceCreated)

    -- ===========================================
    -- 4. Calculate Engagement Score
    --    (Weighted sum of likes, comments, avg session, unique viewers)
    -- ===========================================
    DECLARE @EngagementScore FLOAT
    SET @EngagementScore = 
        (0.4 * ISNULL(@Likes,0)) +
        (0.3 * ISNULL(@Comments,0)) +
        (0.2 * ISNULL(@AvgSessionDuration,0)) +
        (0.1 * ISNULL(@UniqueViewers,0))

    -- ===========================================
    -- 5. Calculate Virality Score
    --    (Based on shares and growth rate of views)
    -- ===========================================
    DECLARE @ViewsLast7Days INT = 0
    DECLARE @ViewsPrev7Days INT = 0
    DECLARE @GrowthRate FLOAT = 0
    DECLARE @ViralityScore FLOAT

    -- Views in last 7 days
    SELECT @ViewsLast7Days = COUNT(*)
    FROM dbo.ContentViews
    WHERE ContentId = @ContentId
      AND ViewDate >= DATEADD(DAY, -7, GETDATE())

    -- Views in previous 7 days
    SELECT @ViewsPrev7Days = COUNT(*)
    FROM dbo.ContentViews
    WHERE ContentId = @ContentId
      AND ViewDate >= DATEADD(DAY, -14, GETDATE())
      AND ViewDate < DATEADD(DAY, -7, GETDATE())

    -- Calculate growth rate (avoid division by zero)
    IF @ViewsPrev7Days > 0
        SET @GrowthRate = (@ViewsLast7Days - @ViewsPrev7Days) * 1.0 / @ViewsPrev7Days
    ELSE IF @ViewsLast7Days > 0
        SET @GrowthRate = 1
    ELSE
        SET @GrowthRate = 0

    -- Virality Score: weighted sum of shares and growth rate
    SET @ViralityScore = (0.7 * ISNULL(@Shares,0)) + (0.3 * @GrowthRate * 100)

    -- ===========================================
    -- 6. Calculate Final Popularity Score
    --    (Weighted sum of all scores and metrics)
    -- ===========================================
    DECLARE @FinalPopularityScore FLOAT
    SET @FinalPopularityScore = 
        (0.25 * ISNULL(@Views,0)) +
        (0.20 * @EngagementScore) +
        (0.15 * @ViralityScore) +
        (0.20 * @RecencyScore * 100) +
        (0.20 * ISNULL(@UniqueViewers,0))

    -- ===========================================
    -- 7. Insert into Return Table
    -- ===========================================
    INSERT INTO @PopularityDetails
    (
        ContentId,
        Title,
        Views,
        Likes,
        Shares,
        Comments,
        AvgSessionDuration,
        UniqueViewers,
        RecencyScore,
        EngagementScore,
        ViralityScore,
        FinalPopularityScore,
        LastUpdated
    )
    VALUES
    (
        @ContentId,
        @Title,
        @Views,
        @Likes,
        @Shares,
        @Comments,
        @AvgSessionDuration,
        @UniqueViewers,
        @RecencyScore,
        @EngagementScore,
        @ViralityScore,
        @FinalPopularityScore,
        @LastUpdated
    )

    -- ===========================================
    -- 8. Return the result
    -- ===========================================
    RETURN
END
GO