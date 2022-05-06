# frozen_string_literal: true

require 'google/cloud/firestore'

require_relative 'firestore_error'

# Class to manage access to Firestore.
class Firestore
  # Format to use for the timestamp of the +updated+ key within the Firestore document.
  DATE_TIME_FORMAT = '%A %d %b %Y %H:%M:%S UTC'

  # Constructor that initialises the Firestore client.
  #
  # @param project_id [String] the ID of the GCP project containing the Firestore database
  # @raise [ArgumentError] if project_id is nil
  def initialize(project_id)
    raise ArgumentError.new('project_id cannot be nil') if project_id.nil?

    Google::Cloud::Firestore.configure { |config| config.project_id = project_id }
    @client = Google::Cloud::Firestore.new
  end

  # Returns all Firestore documents within a collection.
  #
  # @param collection_name [String] the name of the Firestore collection containing the documents
  # @return [Enumerator] list of documents within the collection
  # @raise [ArgumentError] if collection_name is nil
  def all_documents(collection_name)
    raise ArgumentError.new('collection_name cannot be nil') if collection_name.nil?

    @client.col(collection_name).list_documents.all
  end

  # Returns a reference to a Firestore document.
  #
  # @param collection_name [String] the name of the Firestore collection containing the document
  # @param document_name [String] the name of the Firestore document
  # @return [Google::Cloud::Firestore::DocumentReference] reference to the document
  # @raise [ArgumentError] if collection_name or document_name are nil
  def document_reference(collection_name, document_name)
    raise ArgumentError.new('collection_name cannot be nil') if collection_name.nil?
    raise ArgumentError.new('document_name cannot be nil') if document_name.nil?

    @client.col(collection_name).doc(document_name)
  end

  # Reads the +data+ key within a Firestore document.
  #
  # @param collection_name [String] the name of the Firestore collection containing the document
  # @param document_name [String] the name of the Firestore document
  # @return [Object] document data
  # @raise [ArgumentError] if collection_name or document_name are nil
  # @raise [FirestoreError] if the +data+ key isn't present within the Firestore document
  def read_document(collection_name, document_name)
    raise ArgumentError.new('collection_name cannot be nil') if collection_name.nil?
    raise ArgumentError.new('document_name cannot be nil') if document_name.nil?

    document = @client.col(collection_name).doc(document_name)
    snapshot = document.get
    raise FirestoreError, 'data key is missing' if snapshot.data.nil?

    snapshot[:data]
  end

  # Saves a Firestore document, overwriting any existing document with the same name.
  #
  # The passed data are saved under a +data+ key within the document.
  # A timestamp at which the operation occurred is saved under the +updated+ key within the document.
  #
  # @param collection_name [String] the name of the Firestore collection containing the document
  # @param document_name [String] the name of the Firestore document
  # @param data [Object] data to save to the Firestore document
  # @raise [ArgumentError] if collection_name or document_name are nil
  # @raise [FirestoreError] if an error occurred whilst saving the document
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
        hash_data[key] = value.class.method_defined?(:to_h) ? value.map(&:to_h) : value
      end
    end

    begin
      document.set({ data: hash_data, updated: Time.now.strftime(DATE_TIME_FORMAT) })
    rescue StandardError => e
      raise FirestoreError, "Failed to save Firestore document #{document_name} in collection #{collection_name}: #{e.message}"
    end
  end
end
