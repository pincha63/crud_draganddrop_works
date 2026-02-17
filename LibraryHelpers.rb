module LibraryHelpers
  def update_author_publishers(author_id, publisher_ids)
    DB[:authors_publishers].where(author_id: author_id).delete
    Array(publisher_ids).each do |pub_id|
      DB[:authors_publishers].insert(author_id: author_id, publisher_id: pub_id)
    end
  end

  def get_relations_map
    DB[:authors_publishers].each_with_object({}) do |row, map|
      (map[row[:author_id]] ||= []) << row[:publisher_id]
    end
  end
end
