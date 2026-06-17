# Session 34 (iter-034) — review summary

## Metadata
- **Sorry count**: 2 → 2 (no regression). Both frozen/superseded: `CechAcyclic.affine` (dead,
  `has_sorry`), `CechHigherDirectImage.lean:~679` (frozen P5b target). Both prover files 0-sorry.
- **Build**: GREEN. `AffineSerreVanishing.lean` and `TildeExactness.lean` both `lake env lean … EXIT 0`,
  diagnostics empty. All 6 new decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`
  (the two "opaque" source-scan warnings in TildeExactness are the word *opaque* inside docstrings — false
  positives, no `opaque` declaration exists).
- **Lanes planned 2, ran 2** (both `mathlib-build`; 2 `session_start` events — iter-033's silent
  single-lane shortfall did NOT recur). **+6 axiom-clean decls** (Lane A +4, Lane B +2); 0 new sorries.
- `archon dag-query`: **gaps = 0**; **unmatched = 3** (1 pre-existing dead `CechAcyclic.affine` + 2 new
  TildeExactness helpers).
- Model: opus.

## Targets attempted

### Lane A — `AffineSerreVanishing.lean` (02KG cover-system): COMPLETE, +4 axiom-clean
The entire 02KG cover-system chain landed — the build iter-033 set up (recipe `analogies/tosheaf-epi.md`)
and that silently failed to run there.

- **`toSheaf_preservesFiniteColimits`** (~L117) — the Mathlib gap-fill (right-exact dual of
  `PreservesFiniteLimits (toSheaf R)`). Routed through the sheafification square
  `PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj)` (Route A): Step 1 `L ⋙ toSheaf R ≅ toPresheaf
  ⋙ presheafToSheaf J Ab` preserves finite colimits; Step 2 descent for a finite diagram via
  `F ≅ (F ⋙ forget R) ⋙ L` + `preservesColimit_of_iso_diagram`. **Universe gotcha**: `toSheaf.{v'}`
  must be pinned or `AddCommGrpCat` universe floats and `HasWeakSheafify` synthesis fails. NEVER through
  `forget` (right adjoint = structural wall that all four iter-032 attempts hit).
- **`toSheaf_preservesEpimorphisms`** (~L155) — one-liner: `PreservesColimitsOfShape WalkingSpan` ⟹
  `preservesEpimorphisms_of_preservesColimitsOfShape`.
- **`affine_surj_of_vanishing`** (~L232) — the `ses_cech_h1` affine instantiation. `Epi S.g` →
  `Epi (toSheaf.map S.g)` → `Sheaf.IsLocallySurjective` (`isLocallySurjective_iff_epi'`) → per-point cover
  → `standard_cover_cofinal` refinement → feed `ses_cech_h1` with `hvanish n g 1 one_pos` → transport the
  global lift across `iSup U = D f`. **Errors seen + resolved** (from `attempts_raw.jsonl`): `failed to
  synthesize Epi S.g` / `Epi ((SheafOfMod...))` (×3) — fixed because `Scheme.Modules` is a NON-reducible
  `def`, so build `hepiTS` via `@Functor.map_epi … (toSheaf.{u} _) (toSheaf_preservesEpimorphisms.{u} _) …`
  pinning `.{u}` and passing the `Epi` instance EXPLICITLY; `rewrite failed: did not find pattern` and
  `Type mismatch congrArg …` — `(toPresheaf).obj GX` vs `GX.presheaf` defeq-not-syntactic, use
  `gπ.naturality_apply` under `erw`, `show` to unify carriers, `Subsingleton.elim` for restriction
  uniqueness, merge `← ConcreteCategory.comp_apply` per-side.
- **`affineCoverSystem`** (~L360) — `BasisCovSystem (Spec R)` with `B = range D`, the three fields
  discharged. **PERF**: `set_option maxHeartbeats 2000000` + two-step `have hfam := injective_cech_acyclicFam …; exact hfam`
  to avoid a whnf blowup on the heavy `sectionCechComplex` carrier.
  **⚠ DESIGN FLAW — see Key findings.**

### Lane B — `TildeExactness.lean` (01I8 Route-P P3): PARTIAL, +2 axiom-clean
- **`tilde_stalkFunctor_map_toStalk`** (L120) — the germ-naturality transport crux (single hardest piece
  the planner asked for). Public Ab-stalk path: `change` `tilde.toStalk` into `germ ⊤ x ∘ toOpenₗ ⊤`
  (defeq), `erw [stalkFunctor_map_germ_apply …]`, `congr 1` to the `⊤`-section equality, unfold `φ.app` +
  `comapₗ_const` (the comap's ring map is `RingHom.id`, so `σ 1 = 1`). `erw` needed: `(tilde M).presheaf`
  vs `(moduleStructurePresheaf R M).presheaf` defeq-not-syntactic. `toStalkₗ` is PUBLIC (unlike `toStalkₗ'`).
- **`tildePreservesFiniteLimits_of_toPresheaf`** (L153) — categorical reduction via
  `Limits.preservesFiniteLimits_of_reflects_of_preserves`; `ReflectsFiniteLimits (toPresheaf)` resolves
  automatically. **Refutes the prior "obstruction 2"** (right-exact + mono ⟹ left-exact glue); the module
  docstring was rewritten to retract that false claim (lean-auditor confirmed the retraction accurate).
- **`tildePreservesFiniteLimits`** (named target) — correctly ABSENT (no sorry). Reduced to a single gap:
  `PreservesFiniteLimits (~ ⋙ toPresheaf)`. Step 1 (R-linearity of the Ab stalk map `σ_x`) attempted; the
  exact blocker is `HSMul`/`Module R` synthesis friction — `(stalkFunctor Ab x).obj …` is only defeq to
  `(tilde N).presheaf.stalk x` (where the `Module R` instance lives); fix is a `show … : … .presheaf.stalk x`
  type-ascription. ModuleCat-stalk path is DEAD (Mathlib privacy). ~100–150 LOC remaining, sharply specified.

## Key findings

### ⚠ HEADLINE: `affineCoverSystem.Cov` is missing its covering condition (design flaw, planner must fix)
**The two review subagents disagreed on the fix direction; I adjudicate in favour of the lean-auditor.**
- **lean-auditor (MAJOR)**: `affineCoverSystem.Cov` = `{c | ∃ n g, c = ⟨ULift (Fin n), i ↦ D(g i.down)⟩}`
  is ALL finite basic-open families, WITHOUT the covering condition `⨆ᵢ D(gᵢ) = D(f)`. Then
  `HasVanishingHigherCech affineCoverSystem F` demands `Ȟ^q = 0` over EVERY finite basic-open family,
  which is **FALSE** for quasi-coherent sheaves — concrete counterexample on `Spec k[x,y]` with the
  NON-covering family `{D(x), D(y)}`: `Ȟ¹(O) = O(D(xy))/(O(D(x)) + O(D(y))) ≠ 0` (the section `x⁻¹y⁻¹`
  is in neither summand). So the gated qcoh seed `affine_cech_vanishing_qcoh` is **unprovable** until Cov
  carries the covering condition. Fix is local: add `Ideal.span (Set.range g) = ⊤` (≡ `⨆ D(gᵢ) = D(f)`
  relative to the base) to the `Cov` predicate; field proofs unaffected (`injective_cech_acyclicFam` is
  cover-agnostic; `affine_surj_of_vanishing` extracts a real cover internally via `standard_cover_cofinal`).
- **lvb-affine (also MAJOR, but WRONG direction)**: same mismatch, but recommended RELAXING the blueprint
  prose to match the over-broad Lean, claiming the broad Cov is "satisfiable for quasi-coherent sheaves
  because sections over `D(g₁⋯gₙ)` equal the localized module." **That reasoning is mathematically false** —
  it conflates exactness of localized sections with Čech vanishing; the auditor's counterexample is decisive.
- **Adjudication**: the blueprint prose (standard covers, with covering condition) is the CORRECT target;
  the LEAN must be tightened, NOT the prose relaxed. The prover's own task-result "Planner reconciliation
  note" ("a broader Cov only strengthens the hypothesis") is therefore WRONG and must not be accepted.
- **Severity**: NOT must-fix-this-iter (nothing currently proved is corrupted; the seed is gated on Lane 2
  and not yet built). It IS a HIGH planner item before the qcoh-seed lane. Documented via a `% NOTE` on
  `def:affine_cover_system` (see manual markers).

### Lane B: the named-target gap is now a single, precisely-located build
`tildePreservesFiniteLimits_of_toPresheaf` collapsed two feared obstructions to one. The residual is
`PreservesFiniteLimits (~ ⋙ toPresheaf)`, and the remaining steps (R-linearity packaging + jointly-
reflecting-stalks assembly) are written out in the task result with the exact synthesis blocker recorded.
lvb-tilde flagged the blueprint sketch as **under-specified** for this remaining build (3 sub-steps + the
dead-ModuleCat-path warning are absent) — a blueprint-writer item before the next prover lane.

### Process: both lanes ran (iter-033 regression did not recur)
`provers-combined.jsonl` shows 2 `session_start` events. The iter-033 HIGH (a planned Lane A silently not
launching) is resolved.

## Notes (LOW)
- 5 Mathlib style-linter minors in AffineSerreVanishing (lean-auditor): `maxHeartbeats` without inline
  comment (L215, L351); `show` that should be `change` (L324, L343); long lines (L220, 357, 358, 360).
  Cosmetic; not correctness.
- lvb-affine LOW: `toSheaf_preservesFiniteColimits` blueprint sketch describes a "retract" argument while
  the Lean uses `isColimitOfPreserves` + `preservesColimit_of_iso_diagram` (same content).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `def:affine_cover_system`: added `% NOTE:` recording the
  `Cov`-missing-covering-condition design flaw, the counterexample, and the adjudication that the LEAN
  (not the prose) must be tightened. No `\leanok` touched. No `\mathlibok` (the 6 new decls are project
  theorems, not bare Mathlib re-exports). No `\lean{...}` renames (prover used the planned names). No stale
  `\notready` to strip (the named-target absence at L4340 is correctly documented).

## Recommendations
See `recommendations.md`. Top items: (1) tighten `affineCoverSystem.Cov` before the qcoh-seed lane;
(2) blueprint the 2 new TildeExactness decls + expand the `lem:tilde_preserves_kernels` sketch with the
3 remaining sub-steps; (3) the ~100–150 LOC `tildePreservesFiniteLimits` build is now frontier-ready.
