# frozen_string_literal: true

require 'google/cloud/firestore'
require 'logger'

# Class to manage access to Firestore.
class Firestore
  # Format to use for the timestamp of the +updated+ key within the Firestore document.
  DATE_TIME_FORMAT = '%A %d %b %Y %H:%M:%S UTC'

  # Constructor that initialises the Firestore client.
  #
  # Params:
  # - project_id: The ID of the GCP project containing the Firestore database.
  #
  # An Argument error is raised if project_id is nil.
  def initialize(project_id)
    raise ArgumentError.new('project_id cannot be nil') if project_id.nil?

    Google::Cloud::Firestore.configure { |config| config.project_id = project_id }
    @client = Google::Cloud::Firestore.new
  end

  # Reads a Firestore document.
  #
  # Params:
  # - collection_name: The name of the Firestore collection containing the document.
  # - document_name: The name of the Firestore document.
  #
  # An Argument error is raised if collection_name or document_name are nil.
  def read_document(collection_name, document_name)
    raise ArgumentError.new('collection_name cannot be nil') if collection_name.nil?
    raise ArgumentError.new('document_name cannot be nil') if document_name.nil?

    document = @client.col(collection_name).doc(document_name)
    snapshot = document.get
    snapshot[:data]
  end

  # Saves a Firestore document, overwriting any existing document with the same name.
  #
  # The passed data are saved under a +data+ key within the document.
  # A timestamp at which the operation occurred is saved under the +updated+ key within the document.
  #
  # Params:
  # - collection_name: The name of the Firestore collection containing the document.
  # - document_name: The name of the Firestore document.
  # - data: Data to save to the Firestore document.
  #
  # An Argument error is raised if collection_name or document_name are nil.
  def save_document(collection_name, document_name, data)
    raise ArgumentError.new('collection_name cannot be nil') if collection_name.nil?
    raise ArgumentError.new('document_name cannot be nil') if document_name.nil?

    document = @client.col(collection_name).doc(document_name)
    if data.is_a?(Array)
      hash_data = []
      data.each { |element| element.respond_to?(:to_h) ? hash_data << element.to_h : hash_data << element }
    end

    if data.is_a?(Hash)
      hash_data = {}
      data.each do |key, value|
        hash_data[key] = value.map(&:to_h)
      end
    end

    begin
      document.set({ data: hash_data, updated: Time.now.strftime(DATE_TIME_FORMAT) })
    rescue StandardError => e
      logger = Logger.new($stderr)
      logger.error("Failed to save Firestore document #{document_name} in collection #{collection_name}: #{e.message}")
      logger.error(e.backtrace.join("\n"))
    end
  end
end
