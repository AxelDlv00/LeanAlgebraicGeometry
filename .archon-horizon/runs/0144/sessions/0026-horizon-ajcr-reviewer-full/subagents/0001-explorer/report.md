Read both PDFs fully. No files or Horizon state changed.

The binding critical path is:

`Div^g` representer -> `DivRankOneOpen` -> `rankOneAbelIso` -> translated cover over `k^s` -> `pic0_sepClosed_representableBy` -> `representableBy_of_finiteGalois_baseChange` -> `pic0_representableBy` -> `jacobianData`. (Plan pp. 2-4, 17-18; supervision p. 2)

The immediate gate is not a fieldwise rank calculation. It is one arbitrary-affine, family-level producer:

- For every affine test family in the intended locus, construct actual `PicRankOneNativePresentation` / `FibrePresented` data.
- Prove cartesian pushforward/base-change comparison maps are `IsIso`.
- Tie `H1 = 0`, `H0` finite-projective locally free of rank one, and the native presentation to the same family, coherently under every affine pullback.
- Consume this package in the public `PicRankOneOpen` / `DivRankOneOpen` interfaces and the canonical inverse. (Supervision p. 4)

The canonical inverse must be built on arbitrary test schemes from the evaluation map `f^*(f_* L) -> L`, giving its zero divisor; it must not choose a generator. It must prove degree `g`, arbitrary base-change compatibility, and equality of Picard class modulo pullback, then establish both inverse identities and `rankOneAbelIso`. (Plan p. 8)

Explicit anti-shortcut rules:

- Fieldwise `h0 = 1` and `H1 = 0` do not establish a natural arbitrary-test inverse.
- Do not make the desired property a hypothesis, use an unrelated existential witness/carrier, or add a wrapper with no consumer.
- No generator-selection construction.
- High-degree Abel is infrastructure/fallback only; its positive-dimensional fibres prevent the desired chart in positive genus. Reopen quotient only with a full non-circular quotient contract. (Plan pp. 3-4, 7-9, 14, 16-17; supervision pp. 3-5)

Required named declarations/files:

- `Picard/Pic0CriticalPath.lean`: imports/checks all endpoint declarations. (Plan p. 5)
- `Picard/Pic0EndgameContract.lean`: `PicRankOneOpen`, `DivRankOneOpen`, `rankOneAbel`, `divisorOfRankOne`, `rankOneAbelIso`, translated-cover theorem, both Pic0 producers. (Plan p. 6)
- `Curve/RelativeCurveBridge.lean`: canonical `relCurve C L` spelling, transports/instances/base-change simp bridges. (Plan p. 7)
- `rankOneAbel_isOpenImmersion`
- `exists_translation_mem_picRankOneOpen`
- `pic0_sepClosed_representableBy`
- `representableBy_of_finiteGalois_baseChange`
- `pic0_representableBy`
- `jacobianData`. (Plan pp. 8-12, 15, 17-18)

Subsequent gates:

1. Translation theorem over separably closed base: for every extension and input `lam`, return a base-field `L0` whose translation is in `PicRankOneOpen`; witness must be explicitly tied to `lam`. (Plan p. 9)
2. Open-cover criterion yields `pic0_sepClosed_representableBy`; this is the first headline milestone. (Plan p. 10)
3. Reuse/import AJC finite-Galois quotient/gluing stack. Descent must return both a scheme and its `RepresentableBy` certificate, then be consumed immediately by `pic0_representableBy`; do not duplicate descent in AJCR. (Plan pp. 10-11)
4. Build every `JacobianData` structure from the same pinned `pic0_representableBy`, not independently chosen representation data. (Plan p. 11)

Endpoint credit/acceptance requires narrow critical-root import and build, immediate downstream consumption, relevant module kernel build, recorded `#print axioms`, obsolete route deletion/specialization, full-project build, and only `[propext, Classical.choice, Quot.sound]` in final axiom output. (Plan pp. 4-5, 14-15)

The supervision memo is point-in-time as of Aug. 7 (p. 7), but its binding diagnosis is clear: Phase 3/5 were genuinely blocked by this same arbitrary-affine producer; Phase 4 should own integration, while translated-cover feeder work stays parked until it can enter the real public interface. (Supervision pp. 1-5)
