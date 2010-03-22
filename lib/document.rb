require 'rubygems'
require 'google_spreadsheet'

class Document
  
  USER = 'michalczyz@gmail.com'
  PASSWD = ''
  DOC_ID = 'tfKWzi9JctXtxcTP6cKBjEw'

  def new_worksheet(tags)
    timestamp = Time.now.strftime("%Y%m%d%H%M")
    @worksheet = document.add_worksheet("#{timestamp} - #{tags}", 200, 6)
  end

  def save
    @worksheet ? @worksheet.save : print("No WorkSheet open") 
  end

  private

  def session
    @session ||= GoogleSpreadsheet.login(USER, PASSWD)
  end

  def document
    @document ||= session.spreadsheet_by_key(DOC_ID)
  end
end