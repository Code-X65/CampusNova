const Dashboard = () => {
    return (
        <div className="space-y-6">
            <h2 className="text-2xl font-semibold text-gray-900">Dashboard</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-white p-6 rounded-lg shadow-sm border">
                    <h3 className="text-lg font-medium text-gray-900">Total Students</h3>
                    <p className="text-3xl font-bold text-blue-600 mt-2">0</p>
                </div>
                <div className="bg-white p-6 rounded-lg shadow-sm border">
                    <h3 className="text-lg font-medium text-gray-900">Active Classes</h3>
                    <p className="text-3xl font-bold text-green-600 mt-2">0</p>
                </div>
                <div className="bg-white p-6 rounded-lg shadow-sm border">
                    <h3 className="text-lg font-medium text-gray-900">Pending Requests</h3>
                    <p className="text-3xl font-bold text-orange-600 mt-2">0</p>
                </div>
            </div>
        </div>
    );
};

export default Dashboard;
