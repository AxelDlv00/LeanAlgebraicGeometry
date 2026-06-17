# Session 40 (iter-040) — Summary

## Metadata
- **Iteration / session**: 040 / session_40
- **Prover lanes this iter**: 1 (QUOT producer, `QuotScheme.lean`). FBC + GR + GF had no prover lane.
- **Sorry count**: 4 → 4 (the 4 pre-existing protected iter-176 scaffold stubs at lines
  126/165/201/228 only). **No new sorry.**
- **New declarations**: 4, all axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Build**: GREEN — `QuotScheme.lean` `lean_diagnostic_messages` errors = 0; producer (a)
  `lean_verify` axiom-clean.

## Targets attempted

### SOLVED — `compositeBasicOpenImmersion` (def, line 1950)
The composite open immersion `j = isoSpec.inv ≫ ι_W ≫ ι_{q.X i} : Spec Γ(q.X i, ι⁻¹ᵁ D(s)) ⟶ Spec R`
identifying the affine slice with the basic open `D(s)`. Domain is the genuine affine `Spec` of the
slice's section ring, obtained from `(IsAffineOpen.Spec_basicOpen s).preimage_of_isOpenImmersion …`
(preimage of an affine under an open immersion is affine ⟹ a genuine `isoSpec`). The range side-goal
of `preimage_of_isOpenImmersion` is discharged by `by rw [Scheme.Opens.opensRange_ι]; exact hs`.

### SOLVED — `pullback_composite_immersion_isIso_fromTildeΓ` (theorem, line 1969) — producer (a), the critical first piece
`IsIso ((pullback j).obj M).fromTildeΓ`. Built the iso `iterated ≅ (pullback j).obj M` from **two**
`Scheme.Modules.pullbackComp` pseudofunctor coherences chained with `≪≫`, then transported the P1
keystone `isIso_fromTildeΓ_restrict_basicOpen` across it via `isIso_fromTildeΓ_of_iso`.

Three gotchas solved (reusable):
- `≫` is **right-associative** (`a ≫ b ≫ c = a ≫ (b ≫ c)`), so the iso composition order is
  `(pullback A).mapIso ((pullbackComp B C).app M) ≪≫ (pullbackComp A (B ≫ C)).app M`.
- `Scheme.Modules.fromTildeΓ` is stated over `Spec (.of R)`; the goal MUST use the explicit
  `@Scheme.Modules.fromTildeΓ (Γ(↑(q.X i), ι⁻¹ᵁ D(s))) (...)` form to avoid an HOU failure unifying
  `Γ(...)` with `CommRingCat.of ↑?m`.
- The `[IsIso ·.fromTildeΓ]` instance from `isIso_fromTildeΓ_restrict_basicOpen` is in nested-`obj`
  form while `e`'s source is in `⋙`/`.comp` form ⟹ TC won't match. **Pass it positionally**:
  `@isIso_fromTildeΓ_of_iso _ _ _ e (isIso_fromTildeΓ_restrict_basicOpen M q s i hs)` — a term-mode
  defeq check succeeds where the syntactic TC match fails. (lean-auditor confirmed this is a
  legitimate Lean 4 idiom, NOT defeq abuse.)

### SOLVED — `compositeBasicOpenImmersion_isOpenImmersion` (instance, line 1991)
`IsOpenImmersion j` via `unfold compositeBasicOpenImmersion; infer_instance` (composite of an iso and
two open immersions). Declared FIRST because `.opensRange` cannot even be *stated* without it.

### SOLVED — `compositeBasicOpenImmersion_opensRange` (theorem, line 2002) — producer (b), range half only
`j.opensRange = D(s)`. `unfold` then rewrite chain
`opensRange_comp_of_isIso → opensRange_comp → opensRange_ι → image_preimage_eq_opensRange_inf →
opensRange_ι`, closing with `inf_eq_right.mpr hs` (`(q.X i) ⊓ D(s) = D(s)` from `D(s) ≤ q.X i`).
`rw [compositeBasicOpenImmersion]` fails (no equational lemma) — use `unfold`. **This is only
sub-claim (1) of the bundled blueprint lemma `lem:composite_immersion_range_basicOpen`**; sub-claims
(2) the f-locus `j ''ᵁ D(f') = D(f) ⊓ D(s)` and (3) `σ(f') = algebraMap R Rₛ f` were NOT landed
(gated on `σ`/`f'` being defined, which needs the TOP gaps).

### BLOCKED (not attempted as code) — `section_localization_hfr_basicOpen` (TOP), keystone `isLocalizedModule_basicOpen_descent`, gap1 `isIso_fromTildeΓ_of_isQuasicoherent`
The prover judged TOP a large coupled ~200–400 LOC ring-identification build (three bridges below),
not a single hard step, and stopped rather than risk a broken half-assembly. **No mathematical
blocker** — Stacks `lemma-invert-f-sections`, well-established. The three coupled bridges:
1. **`S` vs `Γ(Spec S, ⊤)`.** The combiner's `σ : S ≃+* A` and `S`-action are over the CommRingCat
   `S`, but the proven `gammaPullbackImageIso_hom_semilinear` is over the structure-sheaf action of
   `Γ(Spec S, V)` via `gammaImageRingEquiv j V`. So the working `σ` must be the **composite**
   `(ΓSpecIso S).symm-as-RingEquiv ≪≫ gammaImageRingEquiv j ⊤`, and producer (c)
   `gamma_image_iso_semilinear_top` must give semilinearity over THAT composite. The genuine hard
   core is how `modulesSpecToSheaf` re-bases along `Scheme.ΓSpecIso S` (`Scheme.lean:606`).
2. **`A` as an `R`-algebra.** `A = Γ(Spec R, D(s))`; need `Algebra R A`, `algebraMap R A f`, scalar
   tower, via restriction-map `.hom.toAlgebra` (pattern at `Scheme.lean:725`, `Restrict.lean:200`),
   with `hf : σ f' = algebraMap R A f` holding by `rfl` when `f' := σ.symm (algebraMap R A f)`.
3. **`h.restrictScalars R` vs the `Hfr` map.** Final `IsLocalizedModule` transport across the
   identification of the `A`-linear section restriction with the `ModuleCat R` `.hom`.

Once TOP lands, both the keystone and gap1 are blueprint one-liners
(`isLocalizedModule_basicOpen_descent_of_basicOpen_cover` ∘
`exists_finite_basicOpen_cover_le_quasicoherentData`; and
`isIso_fromTildeΓ_iff_isLocalizedModule_restrict`).

> Note: the prover reported no LLM API key in env (the `GEMINI_CLI_*` vars are IDE-server vars, NOT
> `GEMINI_API_KEY`), so the informal agent was unavailable for the TOP sketch.

## Key findings / patterns
- **Pseudofunctor `pullbackComp` coherence chaining** to identify an iterated pullback with a
  composite pullback, then transport an `IsIso fromTildeΓ` via `isIso_fromTildeΓ_of_iso`. Reusable
  for any composite-immersion `fromTildeΓ` transport.
- **Positional instance passing** (`@lemma _ _ _ e (instProof)`) when the supplied `[IsIso …]`
  instance is in a different syntactic form (nested-`obj` vs `⋙`/`.comp`) than the goal expects.
- **`unfold` not `rw`** to expand a `noncomputable def` with no equational lemma; declare the
  `IsOpenImmersion` instance before any `.opensRange`/`''ᵁ` statement.

## Critic / auditor dispositions (this review phase)
- **lean-auditor `quot-iter040`**: **0 must-fix / 0 major / 2 minor**. All 4 new decls axiom-clean,
  no sorry/`native_decide`/placeholder, no defeq abuse (the `@`-positional idiom is legitimate), no
  orphaned helpers. Minor: stale `iter-177+` labels on the pre-existing scaffold-stub docstrings
  (inherited from the extracted-from source project); trivial duplicated
  `(by rw [opensRange_ι]; exact hs)` at lines 1976/1983. → `recommendations.md` LOW.
- **lean-vs-blueprint-checker `quot-iter040`**: **1 must-fix / 1 major / 2 minor**. MUST-FIX: the
  `\lean{}` pin on `lem:composite_immersion_range_basicOpen` names a non-existent
  `composite_immersion_range_basicOpen`; the landed decl is `compositeBasicOpenImmersion_opensRange`
  and proves only 1 of the block's 3 bundled claims. MAJOR: that block needs a partial-formalization
  NOTE. Minor×2: the two `lean_aux` defs lack blueprint blocks (coverage debt). All 4 decls otherwise
  faithful + axiom-clean. → handled below + `recommendations.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:composite_immersion_range_basicOpen`: added a `% NOTE (iter-040)`
  recording that only sub-claim (1) `j.opensRange = D(s)` is formalized (as
  `compositeBasicOpenImmersion_opensRange`), and that the `\lean{}` pin is **intentionally left at the
  non-existent bundled name** so `sync_leanok` does NOT mark this 3-claim block `\leanok` from a
  range-only decl (that would be a false-done). The checker's "must-fix: re-pin to the partial decl"
  was deliberately NOT applied for exactly this laundering reason; instead the planner is asked
  (`recommendations.md §1`) to SPLIT the block.

No `\leanok` added/removed by hand (sync_leanok added 20 this iter, sha `c83db86`).

## Structural / doctor
- **blueprint-doctor**: **0 findings** (all chapters `\input`'d, all `\ref`/`\uses` resolve, no new
  `axiom`). The broken `\lean{}` pin is NOT a doctor finding — the `\label` exists and is referenced;
  only the Lean-name binding is wrong, which the doctor does not check.
- **sync_leanok** (iter 40, sha `c83db86`): **+20 `\leanok`, 0 removed**
  (Picard_GrassmannianCells, Picard_QuotScheme).
- **leandag**: gaps = 0, frontier = 5, unmatched = 4 (3 new QUOT `lean_aux` from this iter +
  1 pre-existing FBC `isIso_unitToPushforwardObjUnit_of_isIso'`).

## Recommendation headline for next plan iter
QUOT is CONVERGING — producer (a) + range half landed; the remaining wall is the TOP geometric
producer's 3 coupled ring-identification bridges (a genuine build, **not** helper-churn). The plan
agent should (1) FIX the blueprint pin/split for `lem:composite_immersion_range_basicOpen`, (2)
dispatch the next QUOT prover bottom-up on producers (c)+(d) then TOP, and (3) dispatch the scheduled
FINAL in-loop FBC Fallback-B round (iter-041, per the iter-040 plan). See `recommendations.md`.
