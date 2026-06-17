# blueprint-writer directive — Picard_QuotScheme.tex (G1-core reduction + gap1 sub-build + coverage)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex`

## Why this dispatch
iter-028 built infrastructure that REDUCES G1-core to a single irreducible lemma. The chapter's G1-core
proof sketch is now over-stated (describes a 3-field compact-open induction that the Lean architecture
no longer follows). The next QUOT prover targets the gap1 sub-build; the chapter must describe that route
faithfully, and two new iter-028 helpers need blueprint blocks (coverage debt).

## Background (from the iter-028 prover + lvb reports — all verified in-file)
The file already contains, axiom-clean:
- `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` — **G1-core ↔ gap1** equivalence.
- `isLocalizedModule_restrict_of_isIso_fromTildeΓ` — once `IsIso M.fromTildeΓ` holds, **all three**
  `IsLocalizedModule` fields (`map_units`/`surj`/`exists_of_eq`) are delivered at once.
- `isIso_fromTildeΓ_of_isLocalizedModule_restrict` — the reverse.

So the irreducible content of G1-core is exactly ONE lemma:
`gap1 = isIso_fromTildeΓ_of_isQuasicoherent : (M : (Spec R).Modules) [M.IsQuasicoherent] → IsIso M.fromTildeΓ`
(the QCoh(Spec R) ≃ Mod R essential-image gap, Stacks 01HA). Source-grep (iter-028) confirmed Mathlib
has NO bridge (no global-presentation-from-quasicoherent, no `IsQuasicoherent → tilde.essImage`, no
global-generation-on-compact); the stalk / local-presentation shortcuts do NOT avoid it.

## Required edits

### 1. Rewrite the G1-core proof sketch (`lem:qcoh_affine_section_localization`)
Replace the 3-field Route-F compact-open-induction sketch (the `surj`/`exists_of_eq` paragraphs are no
longer the planned path) with the Lean-derived reduction:
> G1-core is equivalent to gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) via
> `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`; once `IsIso M.fromTildeΓ` holds, all three
> `IsLocalizedModule` fields are delivered by `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`.
Set `\uses{}` accordingly. Elevate **gap1** (`lem:qcoh_affine_isIso_fromTildeΓ`) as the primary stated
gap, not a downstream corollary of G1-core.

### 2. Add the gap1 sub-build node (the prover's THIS-ITER target) — `lem:exists_isIso_fromTildeΓ_basicOpen_cover`
This is the irreducible Step-1 ingredient handed off by the iter-028 prover. State it and give the
informal proof route (Stacks 01HA, with the Mathlib structure-sheaf template named):
- **Statement:** for `M : (Spec R).Modules` with `M.IsQuasicoherent`, there is a FINITE family of
  basic opens `{D(gⱼ)}` with `⨆ D(gⱼ) = ⊤` such that for each `j`, the restriction of `M` to `D(gⱼ)`
  has `IsIso ((M|_{D(gⱼ)}).fromTildeΓ)` (equivalently `M|_{D(gⱼ)} ≅ Ñⱼ` for a module `Nⱼ` over `R_{gⱼ}`).
- **Proof route:** from `M.IsQuasicoherent = Nonempty M.QuasicoherentData`, take the cover `{Xᵢ}` of `⊤`
  with local presentations `(M.over Xᵢ).Presentation`; refine each `Xᵢ` to basic opens `D(g) ⊆ Xᵢ`
  (`PrimeSpectrum.isBasis_basic_opens`); extract a finite subcover (`CompactSpace (PrimeSpectrum R)`);
  transport each presentation across `D(g) ≅ Spec R_g` to `IsIso ((M|_{D(g)}).fromTildeΓ)` — the
  site-`over` ↔ scheme-pullback transport (`QuasicoherentData.Presentation.ofIsIso` / `Presentation.map`
  under the restriction functor). The base identification per-`D(g)` is the file's
  `isLocalizedModule_tilde_restrict` + Mathlib `isIso_fromTildeΓ_of_presentation`.
- Note the inductive-assembly half (gap1 from the finite cover) is a module Mayer–Vietoris gluing on
  `modulesSpecToSheaf.obj M` — port of `exists_eq_pow_mul_of_isCompact_of_isQuasiSeparated`
  (`Mathlib/.../QuasiSeparated.lean`) via `TopCat.Sheaf.existsUnique_gluing` / `eq_of_locally_eq'`
  (sidestepping the `CommRingCat`-specific `objSupIsoProdEqLocus`).
- `\uses{}`: `lem:isLocalizedModule_tilde_restrict`, `lem:isLocalizedModule_basicOpen_of_presentation`,
  the QuasicoherentData / `isIso_fromTildeΓ_of_presentation` Mathlib anchors. Wire gap1's `\uses{}` to
  depend on this sub-build.

### 3. Add the two coverage-debt blocks (iter-028 helpers, both axiom-clean in-file)
- `lem:isLocalizedModule_basicOpen_of_presentation` — `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}`.
  "For a globally-presented `M : (Spec R).Modules`, the restriction `Γ(M,⊤)→Γ(M,D(f))` is
  `IsLocalizedModule (powers f)`." One-line proof: Mathlib `isIso_fromTildeΓ_of_presentation` then the
  file's `isLocalizedModule_restrict_of_isIso_fromTildeΓ`.
  `\uses{lem:isIso_fromTildeΓ_of_presentation_mathlib, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ}`.
- `lem:map_units_restrict_basicOpen` — `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}`.
  "For ANY `M : (Spec R).Modules` (no quasi-coherence), every element of `powers f` acts invertibly on
  `Γ(M,D(f))`." Proof via the Mathlib End-unit lemma (see anchor below). Note it holds unconditionally,
  so `map_units` contributes nothing to the gap.

### 4. Add a `\mathlibok` Mathlib-dependency anchor
- `lem:isUnit_algebraMap_end_basicOpen_mathlib` — `\lean{AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen}`,
  marked `\mathlibok`. Statement: `IsUnit (algebraMap R (Module.End R Γ(M,D f)) f)` for any
  `M : (Spec R).Modules`. This is what `map_units_restrict_basicOpen` actually uses (the chapter
  previously pointed at `RingedSpace.isUnit_res_basicOpen`, a different API NOT used in Lean — update the
  G1-core map_units note to cite this anchor instead).

## Out of scope
- Do NOT add/remove `\leanok`.
- The 4 protected stubs (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`representable`) — untouched.
- SNAP / `sectionGradedRing` — untouched.

## References
Stacks 01HA (quasi-coherent sheaves on affines, QCoh≃Mod). `references/stacks-schemes.md` →
`stacks-schemes.tex` (tag 01I9 `lemma-widetilde-pullback`) and `references/stacks-properties.tex` are
the relevant local sources; read the actual `.tex`/source before writing any `% SOURCE QUOTE:`. If you
need a tag not yet downloaded (e.g. 01HA proper), `references/**` is in your write domain so you may
dispatch a reference-retriever; otherwise keep the route prose to the project's notation without a
fabricated verbatim quote.
