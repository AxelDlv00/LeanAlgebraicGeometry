Audit complete; no files or Horizon state were modified.

Key findings sent to `/root`:

- Rebuild headline is `AlgebraicJacobian/Challenge.lean`; all 13 core endpoint declarations remain `sorry`-backed, including `Jacobian`, `instGrpObj`, smooth relative dimension, properness, geometric irreducibility, `ofCurve`, Albanese `∃!`, functoriality, and base-change coherence.
- `JacobianData` is clean and intentionally downstream. Its structure is in `Picard/JacobianData.lean:87-100`; `PicRepDatum.toJacobianData` requires an explicit `QuasiCompact` certificate.
- Current clean endpoints are only separably closed: `canonicalRankOneAbelIso`, `pic0_sepClosed_representableBy`, `picRepDatumSepClosed`, and `jacobianDataSepClosed`. No arbitrary-field `pic0_representableBy` or `finiteStageRepresentableBy` exists yet.
- `JacobianData` transitively reaches `Challenge.lean` through the degree/Riemann–Roch/base-change cone, so importing `JacobianData` into `Challenge.lean` would create a cycle. Integration must happen in a later bridge/root module or after extracting lower-level statement definitions.
- After arbitrary-field Pic0 representation lands, remaining work includes QC, properness/GI via `AbelSourceData`, smooth relative-dimension genus, `ofCurve`/pointing, Albanese existence, functor laws, and coherent base-change proofs.
- The sibling AJC project is a separate API: its headline is `AlgebraicJacobian/Jacobian.lean`, using full étale Picard representability (`fgaPicardRepresentability`, `PicSchemeEt`, `Pic0SchemeEt`), not Rebuild’s degree-zero `pic0TypeFunctor`/`PicRepDatum`. Direct drop-in reuse is impossible without an explicit bridge or project restructuring.
- Both reviewer PDFs confirm the route:
  `PicRankOneOpen -> rankOneAbelIso -> translated cover -> pic0_sepClosed_representableBy -> finite-Galois descent -> pic0_representableBy -> JacobianData`.

The shared index already contains pre-existing staged deletions; I did not commit or alter them.
