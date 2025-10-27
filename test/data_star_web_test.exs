defmodule DstarExWebTest do
  use ExUnit.Case

  test "csrf gets added into the headers" do
    val = DstarEx.Web.dsget("/test", csrf: "123")
    assert val == "@get('/test', { 'headers': { 'x-csrf-token': '123' } })"
  end

  test "csrf is added to additional headers, not replacing them" do
    val = DstarEx.Web.dspost("/test", csrf: "123", headers: [x: "y"])
    assert val == "@post('/test', { 'headers': { 'x-csrf-token': '123', 'x': 'y' } })"
  end

  test "csrf is skipped if not present" do
    val = DstarEx.Web.dspost("/test", headers: [x: "y"])
    assert val == "@post('/test', { 'headers': { 'x': 'y' } })"
  end

  test "non-header keywords are at the top level" do
    val = DstarEx.Web.dspost("/test", foo: "bar")
    assert val == "@post('/test', { 'foo': 'bar' })"
  end
end
