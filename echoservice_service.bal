import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: GRPC_ECHO_SERVICE_DESC}
service "EchoService" on ep {

    remote function SayHello(HelloRequest value) returns HelloReply|error {
        return {message: "Hello " + value.name};
    }
    remote function SayHelloStream(HelloRequest value) returns stream<HelloReply, error?>|error {
        StringArrayClass names = new ();
        stream<HelloReply, error?> namesStream = new (names);
        return namesStream;
    }
}

class StringArrayClass {
    HelloReply[] namesArr = [{message: "Hello"}, {message: "Hi"}, {message: "Hola"}, {message: "Aloha"}];
    int i = 0;

    public isolated function next() returns record {|HelloReply value;|}|error? {
        if self.i < self.namesArr.length() {
            record {|HelloReply value;|} result = {value: self.namesArr[self.i]};
            self.i += 1;
            return result;
        } else {
            return ();
        }
    }
}
