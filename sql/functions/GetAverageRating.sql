CREATE FUNCTION GetAverageRating
(
    @content_id INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @avg_rating DECIMAL(5,2);

    SELECT @avg_rating = COALESCE(AVG(CAST(rating AS DECIMAL(5,2))), 0)
    FROM Ratings
    WHERE ContentID = @content_id;

    RETURN @avg_rating;
END
GO