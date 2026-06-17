# Session 56 (iter-056) — Review Summary

## Metadata
- Iteration: 056. 3 prover lanes (FLAT prove, GRQUOT prove, SNAP mathlib-build), all `done`.
- Active sorry (project): **13 → 12** (FLAT 1→1, GRQUOT 4→3, SNAP 0→0; QuotScheme 4 + FlatBaseChange 4 untouched).
- New axiom-clean decls: **4** (`gf_flat_of_isEpi`, `gf_isEpi_restrict_of_affine_le`, `Scheme.Modules.glue`,
  `relTensorTriplePresheaf`). Headline declaration CLOSED: **1** (`Scheme.Modules.glue`).
- Build GREEN all 3 touched files. sync_leanok iter-056 sha `d56bebc` **+7/-0**. blueprint-doctor **0 findings**.
  dag gaps=0, unmatched=5 (see recs). All 4 new decls `lean_verify` = `{propext, Classical.choice, Quot.sound}`
  (verified first-hand this phase).

## Targets

### genericFlatness (FlatteningStratification.lean) — PARTIAL (qualitative breakthrough)
The documented 5-iter blocker "open-immersion flat-epimorphism base change absent from Mathlib" was **never
missing**. Prover searched `Algebra.Epi`/`TensorProduct.lid'` and built it axiom-clean:
- **`gf_flat_of_isEpi`** (L3026, 3-line proof): `[Algebra.IsEpi A R][Module.Flat A M]` (tower `A→R→M`) ⟹
  `Module.Flat R M`, via `IsBaseChange.of_equiv (TensorProduct.lid' A R M)` + `Module.Flat.isBaseChange`.
- **`gf_isEpi_restrict_of_affine_le`** (L3041): affine `U ≤ V` ⟹ `Algebra.IsEpi Γ(S,V) Γ(S,U)`.
  Route: `rw [← CommRingCat.epi_iff_epi]`; `IsAffineOpen.map_fromSpec` ⟹ `Spec.map ρ ≫ hV.fromSpec = hU.fromSpec`,
  `hU.fromSpec` open-immersion mono ⟹ `Mono (Spec.map ρ)` (`mono_of_mono`); reflect through `Scheme.Spec`
  (`Functor.mono_of_mono_map`) ⟹ `Mono ρ.op`; `unop_epi_of_mono`.
- `genericFlatness` restructured (L3192+): `hf`/`choose!` strengthened to RETAIN the per-patch freeness witness
  `hfree`; per-piece sorry now sets `V = D(f)`, restricts the given `Γ(S,U)`-action to `Γ(S,V)` (`modV`), gets
  `Algebra.IsEpi Γ(S,V) Γ(S,U)`, and `exact gf_flat_of_isEpi …` to DESCEND the goal to `flatV : Module.Flat
  Γ(S,V) Γ(F,Dg)` (L3287). The base-descent is fully discharged.
- **Residual sorry (L3285, `flatV`):** per-piece flatness over `A_f`. Route documented in-code with named tools
  (`Module.free_of_isLocalizedModule` + B1 `gf_flat_localizedModule_sameBase` + `isLocalizedModule_basicOpen`,
  transport `Γ(F,Dg)=Γ(F,Dḡ)` via `hbo`). **Pure in-Mathlib localization assembly, NO Mathlib gap.** Prover
  stopped to lock the keystone green rather than risk a ~150-250 LOC instance/transport grind leaving the file broken.

### Scheme.Modules.glue (GrassmannianQuot.lean) — SOLVED (axiom-clean)
Closed via **effective descent as an equalizer of pushforwards**, NOT the blueprint's hand-built
`gluePresheaf`/`gluePresheafModule`/`gluePresheafIsSheaf` route. `glue := Limits.equalizer a b` where
`a,b : ∏ᶜ i, (D.ι i)_* (M i) ⇉ ∏ᶜ (i,j), (j_ij)_* (f_ij^* M i)` (`j_ij = f_ij ≫ ι_i`). Leg `a`: project factor `i`,
`pullbackPushforwardAdjunction (f_ij)` unit, push `ι_i`, `pushforwardComp`. Leg `b`: factor `j`, adjunction unit
for `t_ij ≫ f_ji`, push `ι_j`, `pushforwardComp`, transport `(g i j).inv`, `pushforwardCongr` along the glue
condition. `X.Modules` `HasLimits` ⟹ equalizer exists + is a sheaf automatically. Cocycle hyps `_hC1`/`_hC2`
unused in the object (pin downstream `glueRestrictionIso`/`glue_unique`). `unfold` exposes a genuine
`equalizer (Pi.lift …) (Pi.lift …)` — NOT `Iso.refl`/laundered. `lean_verify` axiom-clean. sorry 4 → 3.
- Remaining 3 sorries (`universalQuotient` L393, `tautologicalQuotient` L404, `represents` L898) were
  planner-deferred and ride on the **GL_d bundle transition cocycle** (net-new infra, NOT reachable from `glue`).

### relTensorActL / presheaf promotion (SectionGradedRing.lean) — BLOCKED (1 decl landed)
- **`relTensorTriplePresheaf`** (L476) added axiom-clean: the objectwise ℤ-tensor triple presheaf
  `U ↦ Γ(U,P) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Γ(U,Q))`, the domain row of the relative-tensor coequalizer. Mirror of
  `relTensorDomainPresheaf`; `map_id`/`map_comp` by nested `TensorProduct.induction_on`. Middle ring factor is
  `X.sheaf.obj.obj U` (CommRingCat) deliberately — `actLmap` needs `[CommRing S]`, absent on the RingCat form.
- **`relTensorActL` NOT added** — naturality is mathematically one `PresheafOfModules.map_smul` step (bridge
  `presheaf_map_apply_coe` located), but blocked by an `↥(P.obj U)` vs `↥((P.presheaf).obj U)` carrier gap:
  the `tmul` induction element and the only ℤ-linear restriction map have rfl-defeq but syntactically distinct
  carriers, so `TensorProduct.map_tmul` won't unify. ~12 routes ruled out (linear lemma + `congr_fun`,
  `show`-ascription, `inferInstanceAs` carrier-alignment, changing `obj` carriers [CASCADES — breaks proven
  `map_id`/`map_comp`], full `simp`/`erw`/`rw`, `conv … enter [2]`). The reduction succeeds in isolation whenever
  carriers agree. Untried handle: build a DISTINCT `↥(P.obj ·)`-carrier ℤ-linear restriction used uniformly.

## Subagent dispositions
- **lean-auditor `iter056`** (1 must-fix / 1 major / 2 minor): 0 laundered proofs, 0 excuse-comments; all 4 new
  decls genuine + axiom-clean; all sorries honest. **must-fix** = stale scaffold NOTE on `glue`
  (GrassmannianQuot L162–173) says the body is "still to be filled" when it IS the closed equalizer at L245–307
  → `.lean` comment, prover/refactor domain → recs TOP §1. major = SNAP superseded handoff block (L559–641)
  contradicts the primary carrier-gap root cause → recs. minors: stale STATUS header `iter-055`→`056` (FLAT L3153),
  30-iter-stale ratification notice (FLAT L3132).
- **lvb-flat `flat-iter056`** (0 must-fix / 2 major): both new GF helpers have blueprint blocks
  (`lem:gf_openImmersion_isEpi`, `lem:gf_flat_descend_isEpi`) with WRONG `\lean{}` pin names — **corrected this
  phase** (see Markers). Statements/sketches match the Lean exactly.
- **lvb-grquot `grquot-iter056`** (0 must-fix / 2 major): blueprint still describes the abandoned hand-built
  `gluePresheaf` route (3 phantom blocks with `\lean{}` pins at non-existent decls); Lean took the valid
  equalizer route. **`% NOTE:` added** flagging the planner to rewrite the Construction prose + drop the phantom
  `\uses`. (Blueprint-prose rewrite is a blueprint-writer job → recs.)
- **lvb-snap `snap-iter056`** (0 must-fix / 1 major): `relTensorTriplePresheaf` missing a blueprint block
  (coverage debt) → recs. New decl clean, no fake/placeholder.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_openImmersion_isEpi`: corrected
  `\lean{...gf_openImmersion_isEpi}` → `\lean{...gf_isEpi_restrict_of_affine_le}` (axiom-clean; unblocks
  `sync_leanok` next iter).
- `Picard_FlatteningStratification.tex`, `lem:gf_flat_descend_isEpi`: corrected
  `\lean{...gf_flat_descend_isEpi}` → `\lean{...gf_flat_of_isEpi}` (axiom-clean; unblocks `sync_leanok`).
- `Picard_GrassmannianQuot.tex`, `def:gr_modules_gluePresheaf`: added `% NOTE:` (iter-056) — the hand-built
  compatible-families presheaf route (this block + `gluePresheafModule` + `gluePresheafIsSheaf`) was ABANDONED;
  `glue` is built directly as the equalizer of pushforwards; the 3 `\lean{}` pins name non-existent decls;
  planner should rewrite the Construction prose of `def:scheme_modules_glue` + drop the phantom `\uses`.

## Notes
- `Scheme.Modules.glue` carries `\leanok` (sync_leanok, confirmed at the chapter block).
- No manual `\leanok` overrides this phase.
