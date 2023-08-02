IdentityServer3 - AccessTokenValidation
====================================================

##### This fork is a migration of the [original project](https://github.com/IdentityServer/IdentityServer3.AccessTokenValidation), via [Rzpeg/IdentityServer3.AccessTokenValidation](https://github.com/Rzpeg/IdentityServer3.AccessTokenValidation), to:
- .NET Framework 4.8
- IdentityModel 4
- OWIN 4
- JWT 5

The nuget package is published as [IdentityServer3.Contrib2.AccessTokenValidation](https://www.nuget.org/packages/IdentityServer3.Contrib2.AccessTokenValidation/)

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
