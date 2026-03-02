import { Link } from 'react-router-dom';

const NotFound = () => {
    return (
        <div className="flex flex-col items-center justify-center py-20 bg-white rounded-xl shadow-sm border border-slate-200">
            <h2 className="text-6xl font-extrabold text-slate-900">404</h2>
            <p className="text-xl text-slate-600 mt-4">Resource not found</p>
            <Link to="/" className="mt-8 bg-slate-900 text-white px-6 py-3 rounded-md hover:bg-slate-800 transition-colors">
                Return to Dashboard
            </Link>
        </div>
    );
};

export default NotFound;
