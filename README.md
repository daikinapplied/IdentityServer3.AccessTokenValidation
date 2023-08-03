IdentityServer3.AccessTokenValidation
====================================================

This fork is a migration of the [original project](https://github.com/IdentityServer/IdentityServer3.AccessTokenValidation), via [Rzpeg/IdentityServer3.AccessTokenValidation](https://github.com/Rzpeg/IdentityServer3.AccessTokenValidation), to [DaikinApplied/IdentityServer3.AccessTokenValidation](https://github.com/daikinapplied/IdentityServer3.AccessTokenValidation):

- .NET Framework 4.8
- System.IdentityModel.Tokens.Jwt 6.7.1
- Microsoft.IdentityModel.Protocols 6.7.1
- IdentityModel 4.0.0
- Microsoft.Owin 4.0.1

The project has been reorganized to match the organization of Daikin Applied projects since the core solution is deprecated (no contribution back expected).

The [NuGet](https://nuget.org) package is published as [IdentityServer3.Contrib2.AccessTokenValidation](https://www.nuget.org/packages/IdentityServer3.Contrib2.AccessTokenValidation/)

OWIN Middleware to validate access tokens from IdentityServer v3.

You can either validate the tokens locally (JWTs only) or use the IdentityServer's access token validation endpoint (JWTs and reference tokens).

```csharp
app.UseIdentityServerBearerTokenAuthentication(new IdentityServerBearerTokenAuthenticationOptions
    {
        Authority = "https://identity.identityserver.io"
    });
```

The middleware can also do the scope validation in one go.

```csharp
app.UseIdentityServerBearerTokenAuthentication(new IdentityServerBearerTokenAuthenticationOptions
    {
        Authority = "https://identity.identityserver.io",
        RequiredScopes = new[] { "api1", "api2" }
    });
```
