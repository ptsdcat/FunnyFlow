CREATE FUNCTION GetTagUsageCount(@tag_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @usage_count INT;
    SELECT @usage_count = COUNT(*)
    FROM ContentTags
    WHERE TagID = @tag_id;
    RETURN @usage_count;
END