<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function index(Request $request)
    {
        //dd($request->userId,$request->shelveId);
        $shelveId = $request->shelveId??'';
        $query = "CALL Pickup_operation($request->userId,'',@a,@b,@c,@d,@e,@f);";
        DB::statement($query);
        $return_query = "SELECT @a as exit_request_id,@b product_id,@c shelve_title,@d shelve_id,@e request_count,@f exited_cont";
        // DB::statement($return_query);

        return DB::select($return_query);

    }
}
