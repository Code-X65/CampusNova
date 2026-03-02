import { Outlet } from 'react-router-dom';

const MainLayout = () => {
    return (
        <div className="min-h-screen bg-gray-50 flex flex-col">
            <header className="bg-white border-b px-6 py-4">
                <h1 className="text-xl font-bold text-gray-900">CampusNova Schools Portal</h1>
            </header>
            <main className="flex-1 p-6">
                <Outlet />
            </main>
            <footer className="bg-white border-t px-6 py-4 text-center text-sm text-gray-500">
                &copy; {new Date().getFullYear()} CampusNova. All rights reserved.
            </footer>
        </div>
    );
};

export default MainLayout;
