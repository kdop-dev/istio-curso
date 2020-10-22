using Genie
import Genie.Router: route
import Genie.Renderer.Json: json
using ExtensibleScheduler
using TimeFrames
using Dates: now
using Dates: UTC
using HTTP

# -- Parameters -- #
SCHED_CALL_INTERVAL = get(ENV, "SCHED_CALL_INTERVAL", "10s")
SCHED_CALL_URL_LST = get(ENV, "SCHED_CALL_URL_LST", "")
SPLIT_CALL_URL_LST = get(ENV, "SPLIT_CALL_URL_LST", "")

service_list_to_call = split(SCHED_CALL_URL_LST, ",")
url_list = split(SPLIT_CALL_URL_LST, ",")

# -- Service --#
Genie.config.run_as_server = true

route("/") do
  (:message => "Hi there!") |> json
end

route("/healthz") do
  (:status => "health") |> json
end

route("/s") do
    invoke_split_url_list()
    return (:split => url_list) |> json
end

Genie.startup(8000, "0.0.0.0", async = true)

function invoke_split_url_list()
  for service in url_list
    println("From print_time_args every $(SCHED_CALL_INTERVAL) calling $(service) - $(now(UTC))")
    r = HTTP.request("GET", service)
    println(r)
  end
end

# -- Schedule -- #
function invoke_sched_url_list()
  for service in service_list_to_call
    println("From print_time_args every $(SCHED_CALL_INTERVAL) calling $(service) - $(now(UTC))")
    r = HTTP.request("GET", service)
    println(r)
  end
end

function schedule_invoke_ws()
    # Use BlockingScheduler with default jobstore, default executor...
    sched = BlockingScheduler()

    # Define what action will be executed
    # TODO: Pass list as parameter
    action = Action(invoke_sched_url_list)

    # Define when job should be triggered
    trigger = Trigger(TimeFrame(SCHED_CALL_INTERVAL))  # periodic job ; priority=0 by default
    
    # Add job to jobstore
    add(sched, action, trigger)

    # Run scheduler
    run(sched)
end

schedule_invoke_ws()
