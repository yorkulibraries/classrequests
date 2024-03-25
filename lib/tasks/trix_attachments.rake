# lib/tasks/refresh_trix_attachments.rake

namespace :trix_attachments do
   desc "Recreate Trix attachments"
   task refresh: :environment do
     ActionText::RichText.where.not(body: nil).find_each do |trix|
       refresh_trix(trix)
     end
   #   ActionText::RichText.where.not(body: nil).limit(5).each do |trix|
   #    refresh_trix(trix)
   #   end
   end

   task update_domain: :environment do 
      ActionText::RichText.where("body like '%https://classrequests.library.yorku.ca%'").each do |t|
         t.update(body: t.body.to_s.gsub('https://classrequests.library.yorku.ca', 'http://classrequests-dev.library.yorku.ca'))
      end
   end
 end
 
   def refresh_trix(trix)
      return unless trix.embeds.size.positive?

      trix.body.fragment.find_all("action-text-attachment").each_with_index do |node, index|
   #      break if index >= 5  # Limit loop to 5 iterations
      embed = trix.embeds.find { |attachment| attachment.filename.to_s == node["filename"] && attachment.byte_size.to_s == node["filesize"] }

      puts "Filename"
   #    if node["filename"].include?("rainmail")
   #       puts "FOUND IT!" 
   #       puts node["filename"]
      puts "***************************"
      puts "Original url is: "
      puts node.attributes["url"].value

      node.attributes["url"].value = Rails.application.routes.url_helpers.rails_storage_redirect_url(embed.blob, host: "https://classrequests.library.yorku.ca") if embed && embed.blob

      puts "After url"
      puts node.attributes["url"].value

      puts  "------------------"
      puts "Original sgid is: "
      puts node.attributes["sgid"].value

      node.attributes["sgid"].value = embed.attachable_sgid if embed && embed.attachable_sgid

      puts "After SIG"
      puts node.attributes["sgid"].value
      puts "***************************"
   #   end 
      end

      puts "Body is now: "
         puts trix.body.to_s
         puts trix.inspect
   #   trix.update_column :body, trix.body.to_s


   end

   