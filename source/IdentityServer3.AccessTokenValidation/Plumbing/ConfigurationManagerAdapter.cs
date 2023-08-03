using System.Threading;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;

namespace IdentityServer3.AccessTokenValidation
{
    internal class ConfigurationManagerAdapter : IConfigurationManager<OpenIdConnectConfiguration>
    {
        private readonly IConfigurationManager<OpenIdConnectConfiguration> _inner;

        public ConfigurationManagerAdapter(IConfigurationManager<OpenIdConnectConfiguration> inner)
        {
            _inner = inner;
        }

        public Task<OpenIdConnectConfiguration> GetConfigurationAsync(CancellationToken cancel)
        {
            var res = AsyncHelper.RunSync(() => _inner.GetConfigurationAsync(cancel));
            return Task.FromResult(res);
        }

        public void RequestRefresh()
        {
            return;
        }
    }
}
