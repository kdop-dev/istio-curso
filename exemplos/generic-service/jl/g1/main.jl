using Genie
import Genie.Router: route
import Genie.Renderer.Json: json
using ExtensibleScheduler
using TimeFrames
using Dates: now
using Dates: UTC
using HTTP

# -- Service --#

Genie.config.run_as_server = true

route("/") do
  (:message => "Hi there!") |> json
end

route("/healthz") do
  "Ok"
end

Genie.startup(8000, "0.0.0.0", async = true)

# -- Schedule -- #


CALL_INTERVAL = get(ENV, "CALL_INTERVAL", "5s")
CALL_SERVICES = get(ENV, "CALL_SERVICES", "")

service_list_to_call = split(CALL_SERVICES, ",")

function print_time_noparam()
    println("From print_time_noparam $(now(UTC))")
end

function print_time_args(x)
  for service in service_list_to_call
    println("From print_time_args every $(CALL_INTERVAL) calling $(service) - $(now(UTC)) $x")
    r = HTTP.request("GET", "http://$(service)")
    println(r)
  end
end

function print_time_kwargs(; a="default")
  for service in service_list_to_call
    println("From print_time_args every $(CALL_INTERVAL) calling $(service) - $(now(UTC)) $a")
    r = HTTP.request("GET", "http://$(service)")
    println(r)
  end
end

function schedule_invoke_ws()
    # Use BlockingScheduler with default jobstore, default executor...
    sched = BlockingScheduler()

    # Define what action will be executed
    action = Action(print_time_kwargs; Dict(:a=>"keyword")...)

    # Define when job should be triggered
    trigger = Trigger(TimeFrame(CALL_INTERVAL))  # periodic job ; priority=0 by default
    
    # Add job to jobstore
    add(sched, action, trigger)

    # Run scheduler
    run(sched)
end

schedule_invoke_ws()
