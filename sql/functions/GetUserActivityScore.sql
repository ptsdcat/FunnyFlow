CREATE FUNCTION GetUserActivityScore (@user_id INT) RETURNS INT AS BEGIN
    DECLARE @content_count INT;
    DECLARE @total_rating INT;
    DECLARE @avg_rating INT;
    DECLARE @comment_count INT;
    DECLARE @like_count INT;
    DECLARE @activity_score INT;
    SELECT @content_count = COUNT(*)
    FROM Content
    WHERE UserID = @user_id;
    SELECT @total_rating = COALESCE(SUM(Rating), 0)
    FROM Ratings
    WHERE ContentID IN (
        SELECT ContentID
    FROM Content
    WHERE UserID = @user_id
    );
    SELECT @comment_count = COUNT(*)
    FROM Comments
    WHERE UserID = @user_id;
    SELECT @like_count = COUNT(*)
    FROM Likes
    WHERE UserID = @user_id;
    SET @avg_rating = CASE
        WHEN @content_count > 0 THEN @total_rating / @content_count
        ELSE 0
    END;
    SET @activity_score = (@avg_rating * 2) + (@comment_count * 3) + (@like_count);
    RETURN @activity_score;
END
GO