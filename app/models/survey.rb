class Survey < ApplicationRecord
  belongs_to :user

  def parse_file(path)
    payloads = Array.new
    workbook = Roo::Excelx.new(path)
    workbook.sheets.each_with_index do |sheet, i|
      payloads.push({ name: sheet, values: workbook.sheet(i).to_matrix })
    end
    self.payloads = payloads
  end
end
