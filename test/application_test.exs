defmodule RetroCounter.ApplicationTest do
  use ExUnit.Case

  test "renders counter image" do
    response = Req.get!("http://localhost:4000/count.svg")

    assert response.status == 200
    assert response.headers["content-type"] == ["image/svg+xml; charset=utf-8"]

    assert response.body ==
             """
             <svg width="200" height="50" viewBox="0 0 200 50" xmlns="http://www.w3.org/2000/svg">
               <rect width="100%" height="100%" fill="black" stroke="white" stroke-width="4"/>
               <text x="195" y="39" fill="white" text-anchor="end" font-size="45" font-family="Courier New">
                 0000001
               </text>
             </svg>
             """
  end
end
