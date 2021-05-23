https://github.com/wtag/juniors-practice-with-github/pull/24#discussion_r487490293

I would say, as going forward we are checking for status and returning :bad_request so maybe move it into a separate service/helper and call from the application controller so that anything related to this bug will respond to this message from there and we don't need to mention it in every controller actions.

Think of this approach and create a follow up story based on it.


103.83.235.135


# Copy CSV to database

COPY attendances
FROM '/home/imam07/Downloads/attendances_202010131906.csv'
DELIMITER ',' CSV HEADER;

# Rails rescue from
include ActiveSupport::Rescuable
rescue_from ActiveRecord::RecordInvalid, with: :failed_checkin_rescuer

private

def failed_checkin_rescuer(error)
 Rollbar.info(error)
 {
   status: false, 
   message: 'check_in failed'
 }
end
