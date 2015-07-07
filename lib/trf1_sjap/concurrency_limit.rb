module Trf1Sjap
  
  class ConcurrencyLimit
    
    def initialize(limit)
      @limit = limit
      @count = 0
      @mutex = Mutex.new
      @cv = ConditionVariable.new      
    end

    def process(&block)
      before_run   
      result = nil
      exception = nil
      begin   
        result = block.call
      rescue Exception => ex
        exception = ex
      end
      after_run
      raise exception if exception
      result
    end
    
    private
    
    def before_run
      @mutex.synchronize do        
        @cv.wait(@mutex) if @count >= @limit          
        @count += 1
      end            
    end
    
    def after_run
      @mutex.synchronize do
        @count -= 1        
        @cv.signal
      end
    end

  end
end