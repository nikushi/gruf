# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module Gruf
  ##
  # A collection of registered gRPC services associated with controllers.
  #
  class Services < Array
    def initialize(*_args)
      super
      @controllers = Hash.new { |h, k| h[k] = [] }
    end

    ##
    # Register a service with the controller class being bound to the service.
    #
    # @param [Class] service_klass
    # @param [Class] controller_klass
    def add(service_klass, controller_klass)
      mutex do
        push(service_klass) unless include?(service_klass)
        @controllers[service_klass] << controller_klass unless @controllers[service_klass].include?(controller_klass)
      end
    end

    private

    ##
    # Handle mutations to the service registry in a thread-safe manner
    #
    def mutex(&block)
      @mutex ||= begin
        require 'monitor'
        Monitor.new
      end
      @mutex.synchronize(&block)
    end
  end
end
