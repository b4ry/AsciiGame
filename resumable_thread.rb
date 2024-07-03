require 'thread'
require './constants/constants'

class ResumableThread
    def initialize(action)
        @mutex = Mutex.new
        @condition = ConditionVariable.new
        @running = false
        @action = action
    end

    def start
        @running = true
        @thread = Thread.new do
            loop do
                @mutex.synchronize do
                    @condition.wait(@mutex) unless @running
                    system(CLEAR_SCREEN)
                end

                @action.call(@thread.object_id)
            
                sleep 1
            end
        end
    end

    def stop
        @mutex.synchronize do
            @running = false
        end
    end

    def restart
        @mutex.synchronize do
            @running = true
            @condition.signal
        end
    end

    def kill
        @thread.kill
    end
end