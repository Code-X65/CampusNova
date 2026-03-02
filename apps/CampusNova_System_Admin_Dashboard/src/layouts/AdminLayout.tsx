import { Outlet } from 'react-router-dom';

const AdminLayout = () => {
    return (
        <div className="min-h-screen bg-slate-100 flex flex-col">
            <header className="bg-slate-900 border-b px-6 py-4">
                <h1 className="text-xl font-bold text-white">CampusNova System Admin Dashboard</h1>
            </header>
            <div className="flex flex-1">
                <aside className="w-64 bg-white border-r p-6 hidden md:block">
                    <nav className="space-y-2">
                        <div className="text-sm font-semibold text-slate-400 uppercase tracking-wider mb-4">Main Menu</div>
                        <a href="/" className="block px-3 py-2 rounded-md bg-slate-100 text-slate-900 font-medium">Dashboard</a>
                        <a href="#" className="block px-3 py-2 rounded-md text-slate-600 hover:bg-slate-50 transition-colors">Schools</a>
                        <a href="#" className="block px-3 py-2 rounded-md text-slate-600 hover:bg-slate-50 transition-colors">System Logs</a>
                        <a href="#" className="block px-3 py-2 rounded-md text-slate-600 hover:bg-slate-50 transition-colors">Settings</a>
                    </nav>
                </aside>
                <main className="flex-1 p-8">
                    <Outlet />
                </main>
            </div>
            <footer className="bg-white border-t px-6 py-4 text-center text-sm text-slate-500">
                &copy; {new Date().getFullYear()} CampusNova Admin Engine.
            </footer>
        </div>
    );
};

export default AdminLayout;
