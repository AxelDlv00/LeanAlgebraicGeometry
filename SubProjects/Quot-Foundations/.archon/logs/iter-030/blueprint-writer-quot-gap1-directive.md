# Blueprint-writer directive — quot-gap1 (chapter Picard_QuotScheme.tex)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (covers `QuotScheme.lean`).

## Strategy context

gap1 = `lem:qcoh_affine_isIso_fromTildeΓ` (`isIso_fromTildeΓ_of_isQuasicoherent`): for
`M : (Spec R).Modules` with `[M.IsQuasicoherent]`, the canonical `M.fromTildeΓ` is an isomorphism
(Stacks 01HA: quasi-coherent on an affine = essential image of `~`). This is the keystone blocking
both QUOT and GF-G1. The prover stalled (STUCK, progress-critic iter-030) on a transport route that
was **based on a false premise** — it believed Mathlib has no restriction functor on
`(Spec R).Modules`. A mathlib-analogist consult (iter-030, full rationale in
`analogies/quot-gap1-transport.md` — READ IT) corrected this and produced a precise 4-step
decomposition. Your job: replace the current gap1 prose with these 4 `\lean{}`-pinned obligations,
clear the coverage debt, and fix the flagged pin/`\uses` issues.

## Mathlib facts to record as `\mathlibok` dependency anchors

Author explicit Mathlib-dependency anchor blocks (statement in project notation, `\lean{}` at the
real Mathlib decl, mark `\mathlibok` — these only):
- `AlgebraicGeometry.Scheme.Modules.restrictFunctor` and `…pullback` (`Modules/Sheaf.lean:319,167`)
  — restriction/pullback of `(Spec R).Modules` along an open immersion (left adjoint, preserves
  colimits, sends `unit ↦ unit`). The project already uses `Scheme.Modules.pullback (U i).ι`.
- `SheafOfModules.Presentation.map` (`Quasicoherent.lean:179`) — transports a `Presentation` across
  a colimit-preserving `F` with `η : F.obj (unit R) ≅ unit S`.
- `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_presentation` (`Tilde.lean:398`) — global
  geometric presentation ⟹ `IsIso fromTildeΓ`.
- `SheafOfModules.QuasicoherentData.bind` (`Quasicoherent.lean:360`) — the worked template for slice
  presentation transport (`Presentation.map e.inverse` via
  `pushforwardPushforwardEquivalence (Over.iteratedSliceEquiv …)`), carrying
  `set_option backward.isDefEq.respectTransparency false` to dodge the slice `IsRightAdjoint`/
  `HasSheafify` synthesis timeout.

## The 4 obligations to blueprint (each its own `\lean{}`-pinned block)

1. **(C) `lem:over_restrict_iso`** — `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictIso}`.
   For `U : X.Opens`, `M.over U ≅ (restrictFunctor U.ι).obj M` (the abstract Grothendieck-slice
   `over` ≅ the geometric `restrict`), induced by the site equivalence `J.over U ≃ Opens(U.toScheme)`
   from `U.ι.opensFunctor` carrying `R.over U ≅ U.toScheme.ringCatSheaf`. This is the ONE lemma that
   must touch the slice site; prove with `backward.isDefEq.respectTransparency false`. Mathlib
   constituents: `Scheme.Hom.opensFunctor` (`OpenImmersion.lean:87`), basicOpen↔`Spec R_r` isos
   (`AffineScheme.lean:566–572`, `isLocalization_basicOpen`), iterated-slice equivs (`Sites/Over.lean`).
   `\uses` the `restrictFunctor`/`restrictFunctorIsoPullback` anchors.

2. **(P1) `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` (name as you see fit;
   pin a sensible target). For `D(r) ≤ q.X i` (from `exists_finite_basicOpen_cover_le_quasicoherentData`),
   `IsIso ((M|_{D(r)}).fromTildeΓ)`: take `q.presentation i : (M.over (q.X i)).Presentation`,
   transport to `D(r)` via `Presentation.map` along the iterated slice (template:
   `QuasicoherentData.bind`), push through `overRestrictIso` and the `D(r) ≅ Spec R_r` iso
   (`Presentation.map` along `pullback`) to a geometric `(Spec R_r).Modules` presentation, then
   `isIso_fromTildeΓ_of_presentation`. `\uses{lem:over_restrict_iso, the Presentation.map +
   bind + isIso_fromTildeΓ_of_presentation anchors, lem:exists_finite_basicOpen_cover_le_quasicoherentData}`.

3. **(D) `lem:section_localization_descent`** — `\lean{AlgebraicGeometry.Scheme.Modules.<name>}`.
   THE KEYSTONE. From "M is locally `~` on a finite basic-open cover `{D(r)}`" conclude
   `∀ f, IsLocalizedModule (powers f) (Γ(M,⊤) → Γ(M, D f))`. Mechanism: the sheaf equalizer over the
   finite cover + `IsLocalization.flat` (localization is exact and commutes with the finite limit) —
   Stacks 01HA / Hartshorne II.5.3. `isLocalizedModule_basicOpen_of_presentation` does NOT close this
   (that needs a GLOBAL presentation of M; here we only have per-`D(r)` data). This lemma is reused by
   gap2 (the section-localization characterization). `\uses` the per-affine (P1) result + `M.isSheaf`
   + `IsLocalization.flat`.
   **CITATION REQUIRED:** read the local source for Stacks 01HA (Properties of Schemes — check
   `references/stacks-properties.tex`; if 01HA is not there, dispatch a reference-retriever child to
   fetch the Stacks tag 01HA) AND/OR Hartshorne II.5.3 (`references/hartshorne-algebraic-geometry.pdf`).
   Add `% SOURCE:`, `% SOURCE QUOTE:` (verbatim, English), and `\textit{Source: …}` per the citation
   discipline. Do NOT fabricate the quote — open the file and copy it.

4. **(4) gap1 assembly `lem:qcoh_affine_isIso_fromTildeΓ`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}`. Feed (D) into the
   in-file `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (`QuotScheme.lean:653`, already
   axiom-clean). One-line assembly. `\uses{lem:section_localization_descent,
   lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict}`.

## Coverage-debt + pin fixes (lean-vs-blueprint-checker `quot` findings, all to clear THIS iter)

- **Add a block for the new helper** `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}`
  (`QuotScheme.lean:730`): "the basic-open finite-cover refinement of a `QuasicoherentData` cover"
  (topological precursor). `\uses` (proof): `Opens.grothendieckTopology`/`CoversTop`/`Sieve.ofObjects`
  membership, `PrimeSpectrum.isBasis_basic_opens`, `iSup_basicOpen_eq_top_iff'`,
  `Ideal.span_eq_top_iff_finite`. It is a proper sub-statement of (P1)'s prerequisites.
- **Fix the `lem:exists_isIso_fromTildeΓ_basicOpen_cover` pin**: its current `\lean{}` points at a
  non-existent decl. Either retarget it to the (P1)/cover decomposition above, restructure it as the
  "finite cover + per-`D(r)` IsIso" statement built from the new helper + (P1), or fold it into (P1).
  Make the pin resolve to a real or clearly-to-be-built decl, with `% NOTE` if the latter.
- **Fix `def:modules_annihilator` `\uses{}`**: remove `lem:annihilator_localization_eq_map` and
  `lem:qcoh_section_localization_basicOpen` from the DEFINITION's `\uses` (they are needed only for the
  characterization, not the definition). Move them to a downstream characterization lemma if present.
- **`private` pins (minor)**: `bijective_comp_of_localizations` and `isIso_sheaf_of_isIso_app_basicOpen`
  are `private` in Lean but publicly pinned — add a `% NOTE` marking them project-internal helpers
  (do NOT change the Lean).

## Out of scope

- The 4 protected stubs (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`representable`); SNAP;
  the annihilator forward direction; `Grassmannian.representable` strengthening (known major, leave the
  existing `% NOTE`).
- Do NOT add `\leanok` (sync owns it). `\mathlibok` ONLY on the Mathlib anchors named above.

Authorized write domains: this chapter + `references/**` (for the Stacks 01HA / Hartshorne II.5.3
fetch via a reference-retriever child if needed).
