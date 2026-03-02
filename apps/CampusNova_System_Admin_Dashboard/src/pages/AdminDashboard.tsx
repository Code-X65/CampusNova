const AdminDashboard = () => {
    return (
        <div className="space-y-8">
            <div className="flex items-center justify-between">
                <h2 className="text-3xl font-bold text-slate-900">System Overview</h2>
                <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors shadow-sm">
                    Generate Reports
                </button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
                    <h3 className="text-sm font-medium text-slate-500 uppercase">Total Tenants</h3>
                    <p className="text-3xl font-extrabold text-slate-900 mt-2">0</p>
                </div>
                <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
                    <h3 className="text-sm font-medium text-slate-500 uppercase">Global Users</h3>
                    <p className="text-3xl font-extrabold text-slate-900 mt-2">0</p>
                </div>
                <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
                    <h3 className="text-sm font-medium text-slate-500 uppercase">Active Subscriptions</h3>
                    <p className="text-3xl font-extrabold text-slate-900 mt-2">0</p>
                </div>
                <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
                    <h3 className="text-sm font-medium text-slate-500 uppercase">System Uptime</h3>
                    <p className="text-3xl font-extrabold text-slate-900 mt-2">99.9%</p>
                </div>
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                <h3 className="text-lg font-semibold text-slate-900 mb-4">Recent System Activity</h3>
                <div className="h-32 flex items-center justify-center border-2 border-dashed border-slate-100 rounded-lg">
                    <p className="text-slate-400">No recent activities found.</p>
                </div>
            </div>
        </div>
    );
};

export default AdminDashboard;
