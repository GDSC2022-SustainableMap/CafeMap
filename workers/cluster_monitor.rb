# frozen_string_literal: true

module Cluster
  # Infrastructure to clone while yielding progress
  module ClusterMonitor
    Cluster_PROGRESS = {
      'STARTED'    => 30,
      'Clustering' => 30,
      'remote'     => 70,
      'Receiving'  => 85,
      'Resolving'  => 95,
      'Checking'   => 100,
      'FINISHED'   => 100
    }.freeze

    def self.starting_percent
      Cluster_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      Cluster_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      Cluster_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      Cluster_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
