class Survey < ApplicationRecord
  belongs_to :user

  def parse_file(path)
    payload = Hash.new
    workbook = Roo::Excelx.new(path)
    workbook.sheets.each_with_index do |sheet, i|
      payload[sheet] = workbook.sheet(i).to_matrix
    end
    self.payload = payload
  end
end
