#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'aws-sdk-v1'
require 'aws-sdk'
require 'thor'
require 'json'

class MyAwsCli < Thor

  desc "s3_list_all_buckets", "List all your bucket accounts."
  def s3_list_all_buckets
    s3 = Aws::S3::Resource.new(region: 'eu-west-1')
    s3.buckets.each do |bucket|
      p bucket.name
    end
  end

  desc "glacier_list_all_vaults", "List all my vaults."
  def glacier_list_all_vaults
    glacier = Aws::Glacier::Resource.new(region: 'eu-west-1')
    glacier.vaults.each do |vault|
      if vault.size_in_bytes != 0
        puts "Vault: " + vault.name + "\nSize: " + (vault.size_in_bytes / 1000000000.0).to_s + " Gbytes\nNum_files: " + vault.number_of_archives.to_s + "\n\n"
      end 
    end
  end

  desc "route53_list_all_record_sets", "List all record sets of all hosted zones."
  def route53_list_all_record_sets
    route53 = Aws::Route53::Client.new(region: 'eu-west-1')
    route53.list_hosted_zones[:hosted_zones].each do |hosted_zone|
      record_sets = route53.list_resource_record_sets(hosted_zone_id: hosted_zone[:id])
      record_sets.each do |page_record_sets|
        page_record_sets[:resource_record_sets].each do |record_sets|
          print record_sets[:name] + " " +  record_sets[:type] + " "
          record_sets[:resource_records].each do |value|
            print value[:value] + " "
          end
          if record_sets[:alias_target]
            print record_sets[:alias_target].dns_name
          end
          puts "\n"
        end
      end
    end
  end

  desc "list_iam_groups_users", "List of IAM groups and users with user Access key."
  def list_iam_groups_users
    iam = Aws::IAM::Resource.new(region: 'eu-west-1')
    iam.users.each do |user|
      print "Username: " + user.name + "\n  Group:[ Policies ]:{ "
      user.groups.each do |group|
        print group.name + ":[ "
        group.policies.each do |policy|
           print policy.name + " "
        end
        print "]"
      end
      print "}\n"
      print "  User-Policies: { "
      user.policies.each do |policy|
        print policy.name + " "
      end
      print "}\n"
      print "\n"
    end
  end

end

MyAwsCli.start(ARGV)

