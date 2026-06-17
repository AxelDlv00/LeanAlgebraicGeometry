# blueprint-writer directive — iter-037 — Route B keystone chain (B1–B6)

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; `% archon:covers` QcohTildeSections.lean + QcohRestrictBasicOpen.lean among others)

## Strategy context (the slice that matters)
Route B proves Stacks 01I8 (`IsQuasicoherent F → IsIso F.fromTildeΓ` on `Spec R`) via the keystone
`lem:qcoh_section_isLocalizedModule` (L3927): the section-restriction `ρ_f : Γ(Spec R,F) → Γ(D(f),F)`
of a qcoh `F` is `IsLocalizedModule (powers f)`. The iter-036 prover delivered the local-model bricks
but BLOCKED the keystone on a base-change bridge. A mathlib-analogist consult (iter-037,
`analogies/bridge.md` — READ IT, it has every Mathlib citation) decomposed the keystone into a
`\uses`-linked chain B0–B6 and confirmed Route B closes with ONE bounded categorical bridge (B3).
Your job: make the chapter's Route B section fully specify this chain so a prover can formalize each
link, and fix the issues two reviewers flagged.

## CRITICAL CORRECTIONS to make (the chapter currently misleads)
1. **`isIso_fromTildeΓ_iff_isLocalizing` / `IsLocalizing` DO NOT EXIST in Mathlib** (analogist verified:
   Tilde's `IsQuasicoherent` section ends at `isIso_fromTildeΓ_of_presentation`). If any block mentions
   them as available, remove that. The assembly `lem:qcoh_isIso_fromTildeGamma` (L4007) already uses the
   correct `lem:isIso_fromTildeGamma_iff_mathlib` (essImage form) — keep that.
2. **The Route B intro (L3852–3872) wrongly claims Route B "bypasses … the restriction-to-basic-open
   base-change chain (P1a)" and that "those blocks remain below as a dormant fallback."** This is FALSE:
   Route B's keystone REUSES `modulesRestrictBasicOpen` (from QcohRestrictBasicOpen.lean) inside the B3
   bridge. Rewrite the intro to say Route B replaces Route P's TWO deep-math walls (`tilde_restrict_basicOpen`
   + `tildePreservesFiniteLimits`) with ONE bounded categorical bridge B3 (`restrict-over-compat`), and
   that `modulesRestrictBasicOpen`/`modulesRestrictBasicOpenIso` are LOAD-BEARING for B3 (not dormant);
   only `TildeExactness`/`tilde_restrict_basicOpen` remain dormant.

## New blocks to ADD (between the four Mathlib-helper blocks ~L3925 and the keystone L3927)

### Three local-model brick blocks (currently FORMALIZED but with NO `\lean{}` pin — coverage debt)
Add a `\begin{lemma}…\end{lemma}` + `\begin{proof}` for each, with `\lean{}` pin and accurate `\uses{}`:
- `lem:tilde_section_isLocalizedModule` → `\lean{AlgebraicGeometry.tilde_section_isLocalizedModule}`.
  Statement: for `M : ModuleCat R` and `f`, the section-restriction `Γ(⊤, M^~) → Γ(D f, M^~)` is
  `IsLocalizedModule (powers f)`. Proof: transport Mathlib's `tilde.toOpen` localization instance along
  the global-sections iso `tilde.isIso_toOpen_top` via `IsLocalizedModule.of_linearEquiv_right`.
  `\uses{}`: a `\mathlibok` anchor for `tilde.toOpen`-is-`IsLocalizedModule` (see below).
- `lem:section_isLocalizedModule_of_isIso_fromTildeGamma` →
  `\lean{AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ}`. Statement: if `[IsIso
  F.fromTildeΓ]` then the section-restriction `Γ(⊤,F)→Γ(D f,F)` is `IsLocalizedModule (powers f)`.
  Proof: conjugate the previous brick by the counit iso pushed through `Sheaf.forget`, using naturality.
  `\uses{lem:tilde_section_isLocalizedModule, lem:qcoh_iso_tilde_sections}`.
- `lem:section_isLocalizedModule_of_presentation` →
  `\lean{AlgebraicGeometry.section_isLocalizedModule_of_presentation}`. Statement: a global
  `F.Presentation` implies the section-restriction localizes. Proof: `isIso_fromTildeΓ_of_presentation`
  then the previous brick. `\uses{lem:section_isLocalizedModule_of_isIso_fromTildeGamma,
  lem:isIso_fromTildeGamma_of_presentation}`.

### The B1–B4 bridge chain (TO-BUILD blocks; give each a `\lean{}` pin naming the intended decl)
Mark each `% NOTE: to-build (Route B, step Bk)`. Statements + one-paragraph informal proofs + `\uses{}`
exactly per `analogies/bridge.md` §"Route B build decomposition". Suggested Lean names + file (use these
as the `\lean{}` pins — provers will create exactly these):
- **B1** `lem:qcoh_finite_presentation_cover` →
  `\lean{AlgebraicGeometry.qcoh_finite_presentation_cover}` (file QcohTildeSections.lean). From
  `IsQuasicoherent F` take `QuasicoherentData F` (cover `Uᵢ`, `coversTop`, `Presentation (F.over Uᵢ)`);
  translate `CoversTop` to `⨆ Uᵢ = ⊤`; feed `lem:exists_finite_basicOpen_subcover` to get finite `gⱼ`
  with `D(gⱼ) ⊆ U_{φⱼ}`, `span{gⱼ}=R`, each carrying a `Presentation (F.over U_{φⱼ})`.
  `\uses{lem:exists_finite_basicOpen_subcover}` + a `\mathlibok` anchor for `QuasicoherentData`/`Presentation`.
- **B2** `lem:presentation_over_basicOpen` →
  `\lean{AlgebraicGeometry.presentationOverBasicOpen}` (file QcohRestrictBasicOpen.lean). Generic: a
  `Presentation (M.over U)` and `D(g) ⊆ U` give `Presentation (M.over (specBasicOpen g))` via
  `Presentation.map` along the further-`over` functor (a left adjoint with unit-iso; nested-over
  instances exist). Independent of B3. `\uses{}` + `\mathlibok` anchor for `Presentation.map`.
- **B3** `lem:restrict_over_compat` (THE BRIDGE) →
  `\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}` (file QcohRestrictBasicOpen.lean).
  `M.over (specBasicOpen g) ≅ modulesRestrictBasicOpen g M` (over-picture ↔ honest `(Spec R_g).Modules`),
  via `pushforwardPushforwardEquivalence` at the open-subscheme site equivalence + structure-sheaf
  compatibility. State clearly it is DISTINCT from `lemma-widetilde-pullback` and NOT discharged by
  `modulesRestrictBasicOpenIso`. `\uses{lem:modules_restrict_basicOpen}` + `\mathlibok` anchor for
  `pushforwardPushforwardEquivalence`.
- **B4** `lem:presentation_modulesRestrictBasicOpen` →
  `\lean{AlgebraicGeometry.presentationModulesRestrictBasicOpen}` (file QcohRestrictBasicOpen.lean).
  Transport the B2 presentation across B3 + `modulesRestrictBasicOpenIso` via `Presentation.ofIsIso` to
  a `Presentation (modulesRestrictBasicOpen g M)`. `\uses{lem:presentation_over_basicOpen,
  lem:restrict_over_compat}` + `\mathlibok` anchor for `Presentation.ofIsIso`.

### `\mathlibok` anchor blocks (state in project notation, `\lean{}` = the real Mathlib decl, mark `\mathlibok`)
Add anchors for: `SheafOfModules.Presentation.map`, `SheafOfModules.Presentation.ofIsIso`,
`SheafOfModules.pushforwardPushforwardEquivalence`, `SheafOfModules.QuasicoherentData`,
`SheafOfModules.restrict_obj` (section comparison `Γ(M.restrict f, U) = Γ(M, f''ᵁU)` by `rfl`),
and the `tilde.toOpen`-is-`IsLocalizedModule` instance. Exact Mathlib names/locations are in
`analogies/bridge.md` §"Key Mathlib facts located".

## REWRITE the keystone proof sketch (`lem:qcoh_section_isLocalizedModule`, proof at L3966–4005)
Replace the vague "Fix j and localize the situation at g_j" paragraph with the explicit chain:
B1 (finite presentation cover) → per `gⱼ`: B2 restricts the presentation to `F.over D(gⱼ)`, B3 bridges
to `modulesRestrictBasicOpen gⱼ F`, B4 gives it a `Presentation`, then
`lem:section_isLocalizedModule_of_presentation` ON `Spec R_{gⱼ}` shows the `gⱼ`-localized section map
is `IsLocalizedModule (powers f)`; finally `lem:isLocalizedModule_of_span_cover` descends to `ρ_f`.
KEEP the non-circularity paragraph (tilde RIGHT-exactness, not left-exact `Γ` of a cokernel). 
Update BOTH `\uses{}` (statement L3930 AND proof L3967) to:
`{lem:isLocalizedModule_of_span_cover, lem:exists_finite_basicOpen_subcover,
lem:qcoh_finite_presentation_cover, lem:presentation_modulesRestrictBasicOpen,
lem:section_isLocalizedModule_of_presentation}`.
**DROP `lem:cech_acyclic_affine` and `lem:free_isQuasicoherent` from the keystone `\uses`** — the
analogist's route uses neither (section comparison is `restrict_obj`-`rfl`; descent is span-cover;
Čech acyclicity is NOT invoked). If you think `free_isQuasicoherent` is still wanted as a remark, keep
it only in prose, not `\uses`. Remove/repoint the stale `% NOTE (iter-036)` planner-action comment now
that the bridge is specified.

## Also fix (reviewer flags)
- `lem:isLocalizedModule_of_span_cover` `\lean{}` pin lists 7 PRIVATE helpers
  (`exists_sum_pow_eq_one`, …) that cannot be referenced by fully-qualified name. Drop them from the
  pin (keep only the public `AlgebraicGeometry.isLocalizedModule_of_span_cover`), or add
  `% NOTE: private helpers, internal only` — your call, but `sync_leanok` must not choke on them.

## Out of scope (do NOT touch)
- `\leanok` markers (forbidden — managed by sync_leanok).
- The Route-A / Route-P dormant blocks (`lem:tilde_restrict_basicOpen` etc.) beyond the one intro
  correction above.
- Any chapter other than `Cohomology_CechHigherDirectImage.tex`.

## Citation discipline
The B-chain is categorical Mathlib bookkeeping (Archon-original construction backed by Mathlib decls):
use `\mathlibok` anchors with the real Mathlib `\lean{}` names from `analogies/bridge.md`; you do NOT
need new Stacks verbatim quotes for B1–B4. The keystone's mathematical content (sections localize) keeps
its existing Stacks 01HV(4) `% SOURCE QUOTE` — leave that intact. If you find you need a fresh source for
the over-picture restriction, you are authorized to spawn a reference-retriever (write-domain includes
`references/**`).
