# Effort Breaker Report

## Slug
gf-geo

## Target
`lem:gf_section_localization_flat_descent` (B2), with secondary surfacing of the
finite-basic-open-cover step from `lem:gf_flat_locality_assembly`.

## Status
COMPLETE — B2 re-expressed as a 3-lemma chain (+ 1 Mathlib anchor); the assembly's
buried covering step extracted as its own `\uses`-linked lemma.

## Effort before → after
- `lem:gf_section_localization_flat_descent` `effort_local`: **1244 → 879**
  (dep_count 3 → now points only at the three new B2.x sub-lemmas).
- `lem:gf_flat_locality_assembly`: covering prose replaced by a one-line cite to the new
  spanning-cover lemma; `effort_local` 2984 → 3180 (the rise is purely the added `\uses`
  edge; the proof body shrank — the monolithic "spanning family" paragraph is now a single
  `\cref`).
- sub-lemmas added: **5** (4 atomic claims + 1 Mathlib anchor).

## Chain added (target ← L_n ← … ← L1)
All in `chapters/Picard_FlatteningStratification.tex`. Planned Lean names under
`AlgebraicGeometry.*` — **decls do NOT exist yet; prover must build them.**

- `\label{lem:mathlib_scheme_basicOpen_res}` `\lean{AlgebraicGeometry.Scheme.basicOpen_res}`
  — **Mathlib anchor**, `\mathlibok` (verified present via loogle: signature
  `X.basicOpen (X.presheaf.map i f) = V ⊓ X.basicOpen f`). effort 0.
- `\label{lem:gf_crossChart_basicOpen_eq}` `\lean{…gf_crossChart_basicOpen_eq}` — **B2.1**,
  cross-chart basic-open identity: `g∈Γ(X,W)`, `ḡ∈Γ(X,W_j)` agreeing on the overlap `O=W⊓W_j`
  with both basicOpens `≤ O` ⟹ `X.basicOpen g = X.basicOpen ḡ` (same `X.Opens`). Pure
  `basicOpen_res`, no module content. `\uses{lem:mathlib_scheme_basicOpen_res}`. effort 646.
- `\label{lem:gf_base_localization_comparison}` `\lean{…gf_base_localization_comparison}` —
  **B2.3**, base comparison: `Γ(S,U)` is a localization of `A_f` (`U ≤ V=D(f)`, both fractions
  of the domain `A` in `Frac(A)`). `\uses{lem:isLocalization_basicOpen_mathlib}`. effort 626.
- `\label{lem:gf_section_localization_twoleg}` `\lean{…gf_section_localization_twoleg}` —
  **B2.2**, two-leg `IsLocalizedModule` transport: for a matched pair `(g,ḡ)` with
  `D=basicOpen g=basicOpen ḡ`, `Γ(F,D)` is simultaneously `(powers g)⁻¹Γ(F,W)` (leg W) and
  `(powers ḡ)⁻¹M_j=(M_j)_ḡ` (leg W_j), connected by `IsLocalizedModule.iso` uniqueness.
  `\uses{lem:gf_crossChart_basicOpen_eq, lem:qcoh_section_localization_basicOpen,
  lem:gf_qcoh_fintype_finite_sections}`. effort 1269.
- `\label{lem:gf_crossChart_spanning_cover}` `\lean{…gf_crossChart_spanning_cover}` — **B2.4**
  (the surfaced assembly step): affine `W`, finite affine `{W_j}` covering `⊇W` ⟹ finite `K`
  with matched pairs `(g_k∈Γ(X,W), ḡ_k∈Γ(X,W_{j(k)}))`, common basic open
  `D(g_k)=basicOpen ḡ_k ⊆ W⊓W_{j(k)}`, and `Ideal.span{g_k}=⊤`. Reuses the existing
  quasi-compact extraction `gf_affine_finite_standard_subcover`.
  `\uses{lem:gf_affine_finite_standard_subcover, lem:gf_crossChart_basicOpen_eq}`. effort 1293.
- Target `lem:gf_section_localization_flat_descent` proof rewritten:
  `\uses{lem:gf_crossChart_basicOpen_eq, lem:gf_section_localization_twoleg,
  lem:gf_base_localization_comparison}` — statement and `\lean{}` preserved verbatim.
- Assembly `lem:gf_flat_locality_assembly`: spanning paragraph repointed to
  `\cref{lem:gf_crossChart_spanning_cover}`; that label added to both `\uses{}` copies.

## Design note — why a *matched pair* `(g, ḡ)`
The directive's claim (1) as literally stated ("`X.basicOpen g = X.basicOpen ḡ` for `ḡ` the
image of `g`") is **false for the bare image of `g`**: `ḡ∈Γ(X,W_j)` can have
`X.basicOpen ḡ` sticking out of `W` beyond the overlap, giving only
`X.basicOpen g = O ⊓ X.basicOpen ḡ`, hence `D(g) ⊊ D(ḡ)` in general. The W_j-leg of
`qcoh_section_localization_basicOpen` then yields `(M_j)_ḡ = Γ(F, D(ḡ))`, *not* `Γ(F, D(g))`.
To conserve the mathematics I made `ḡ` an **explicit matched datum** (agrees with `g` on the
overlap **and** `basicOpen ḡ ≤ O`), so the equality `D(g)=D(ḡ)` genuinely holds (B2.1), and the
W_j-leg lands on the right group. The existence of such matched pairs — the real geometric core —
is isolated in **B2.4** (common basic opens of two affines form a basis of their overlap), where
it belongs. This keeps every step honest and atomic.

## Still hard (re-break candidates)
- `lem:gf_crossChart_spanning_cover` (effort 1293) and `lem:gf_section_localization_twoleg`
  (effort 1269) are the two largest. Each is a **single mathematical claim** (directive's fine
  granularity floor), so I did not split further. If the prover stalls:
  - **twoleg**: the only non-mechanical move is the double application of
    `qcoh_section_localization_basicOpen` + `IsLocalizedModule.iso` uniqueness — already atomic.
  - **spanning_cover**: the residual content is the "opens basic in both `W` and `W_j` form a
    basis of `W∩W_j`" fact. If hard, break out a dedicated lemma
    `gf_common_basicOpen_basis` (for `x∈W∩W_j` produce `g∈Γ(X,W), ḡ∈Γ(X,W_j)` with
    `x∈D(g)=D(ḡ)⊆W∩W_j`) and have spanning_cover consume it + `gf_affine_finite_standard_subcover`.
    Search Mathlib first: `IsAffineOpen` intersection / `PrimeSpectrum.isBasis_basic_opens`
    on the overlap, possibly `IsAffineOpen.exists_basicOpen_le`.

## Could not decompose (strategy items)
- None. B2 fully re-expressed; the geometric crux is concentrated in `gf_crossChart_spanning_cover`
  (a known standard fact), the algebra-free identity in `gf_crossChart_basicOpen_eq`, and the
  module transport in `gf_section_localization_twoleg`.

## Notes for dispatcher
- **`\lean{}` names assigned by convention (confirm/scaffold these 4 + 1 anchor):**
  `AlgebraicGeometry.gf_crossChart_basicOpen_eq`,
  `AlgebraicGeometry.gf_section_localization_twoleg`,
  `AlgebraicGeometry.gf_base_localization_comparison`,
  `AlgebraicGeometry.gf_crossChart_spanning_cover`, and the Mathlib anchor
  `AlgebraicGeometry.Scheme.basicOpen_res` (real decl, `\mathlibok`, verified via loogle).
- **B2 Lean signature**: the blueprint B2 statement (preserved verbatim) phrases `ḡ` as "the
  image of `g`". The honest Lean decl for B2 / `gf_section_localization_twoleg` should take `ḡ`
  (and the proof that `basicOpen g = basicOpen ḡ ≤ O`) as an **explicit argument**, supplied by
  `gf_crossChart_spanning_cover` at the assembly call site. Flag for the plan agent so the
  scaffolded signature matches.
- **B2.3 subtlety** (`gf_base_localization_comparison`): the assembly quantifies over a *general*
  affine `U ≤ V`, not just basic opens, so `Γ(S,U)` over `A_f` is realised via the integral
  scheme's function-field embedding rather than a single `IsLocalization.Away`. For the
  downstream flatness use, `A_f → R` being a flat localization (open immersion) is all that is
  consumed; if `IsLocalization` is awkward to produce for non-basic `U`, the prover may weaken the
  Lean statement to "`A_f → R` flat" without breaking the assembly. Noted, not silently changed.
- No new macros required. No `\leanok` touched (sync owns it).

## References consulted
- None retrieved anew. New geometric sub-lemmas are standard-fact restatements consistent with the
  existing unsourced B2/assembly blocks (which cite Nitsure §4 / Hartshorne III.9 inline in prose);
  no verbatim source port, so no `% SOURCE QUOTE` machinery added — matching the surrounding blocks.
