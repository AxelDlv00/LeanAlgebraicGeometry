# Session 49 (iter-049) — Summary

## Metadata
- Sorry: global unchanged. FlatteningStratification 1→1 (pre-existing `genericFlatness`), SectionGradedRing 0→0.
- **+3 axiom-clean decls** across 2 lanes; 10 SNAP helpers privatized; 0 new sorry.
- Targets: GF seam-1 (1a/1b/1c + assembly) + SNAP (`sectionsMul`, `tensorPowAdd`).
- Build GREEN (`lake build SectionGradedRing` 2417 jobs; FlatteningStratification diagnostics clean).
- lean_verify all decls: `{propext, Classical.choice, Quot.sound}`.

## GF seam-1 lane (FlatteningStratification.lean)

### `gf_affine_finite_standard_subcover` (1b, ~L2355) — SOLVED
Affine-topology refinement of an arbitrary open cover to a finite standard-basic-open subfamily.
- Per `x : W`: `TopologicalSpace.Opens.mem_iSup.mp (hcov x.2)` → member `U i ∋ x`; `hW.exists_basicOpen_le`
  → `f : Γ(X,W)` with `D(f) ≤ U i`, `x ∈ D(f)`; `choose`; `hW.self_le_iSup_basicOpen_iff` → `span = ⊤`;
  `Ideal.span_eq_top_iff_finite` → finite `t`.
- **Error → fix:** `obtain ⟨i,hi⟩ := Opens.mem_iSup.mp (hcov x.2)` → `Unknown identifier Opens.mem_iSup.mp`
  + `rcases failed: not an inductive datatype`. Fix = fully qualify `TopologicalSpace.Opens.mem_iSup`
  (bare form clashes inside `namespace AlgebraicGeometry`).

### `gf_finite_gen_iff_free_epi` (1c, ~L2390) — SOLVED
Definitional repackaging of `SheafOfModules.GeneratingSections`: fwd `⟨σ,hσ⟩ ↦ ⟨σ.I, hσ.finite, σ.π, σ.epi⟩`;
rev builds `GeneratingSections` with `s := M.freeHomEquiv π`, `epi` recovered via `Equiv.symm_apply_apply`.
Stated in abstract `SheafOfModules.{u} R` generality (3 Generators-API typeclasses + explicit universes) so it
applies to the sliced `F.over Y`. **Blueprint prose says "quasi-coherent" — Lean needs none (strictly more
general); flagged `% NOTE:`.**

### `gf_localGenerators_restrict` (1a) — BLOCKED (not added)
restriction-of-generation ≡ slice restriction functor preserving EPIMORPHISMS.
- **Attempt 1 (pushforwardComp):** `F.over V ≅ pushforward(Over.map f)(F.over Y)`, push `σ.π`. FAILED —
  `pushforward` is the RIGHT adjoint (`pullbackPushforwardAdjunction : pullback ⊣ pushforward`), preserves
  limits not epi.
- **Attempt 2 (left-adjoint pullback):** needs `pullback φ (F.over Y) ≅ F.over V` (Beck–Chevalley, absent) +
  `Over.map f` Final (`freeFunctorCompPullbackIso` requirement, false in general). FAILED.
- **Sound route (iter-050):** transport `σ.π` along `Scheme.Modules.overRestrictPullbackIso` (geometric
  `pullback U.ι`, epi+free preserving — QUOT gap1 plumbing). Do NOT retry the abstract routes.

### `gf_finiteType_affine_finite_cover_generated` (assembly) — BLOCKED behind 1a
Every ingredient in hand (`exists_localGeneratorsData` + 1b + 1c) except 1a, which the per-`g` generation step
consumes; assembles mechanically once 1a lands.

## SNAP lane (SectionGradedRing.lean)

### `sectionsMul` (~L178) — SOLVED
Lax-monoidal Γ-multiplication = Γ(⊤)-component of the sheafification unit at the objectwise presheaf tensor
`P = F.toPsh ⊗ G.toPsh`: `((sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P).app (op ⊤)`;
codomain `(tensorObj F G).val.obj (op⊤)` defeq by `rfl`.
- **Dead ends (ring-expression diamond):** a `TensorProduct R₀ Γ(F) Γ(G) →ₗ[R₀]` signature and `.hom`-to-`→ₗ`
  both FAIL — `F.val.obj(op⊤)` module is over `↑(X.ringCatSheaf.obj.obj(op⊤))` while the firing `CommRing` is
  on `↑((X.sheaf.obj ⋙ forget₂).obj(op⊤))` (defeq, synthesis won't bridge); local `CommRing` makes a Semiring
  diamond that breaks the ModuleCat instance. The `ModuleCat ⟶` form typechecks (object cats defeq).
- Also marked 10 layer-1 helpers `private` per the plan's coverage-hygiene objective.

### `tensorPowAdd` (`lem:sheafTensorPow_add`) — BLOCKED (not added)
Needs the sheaf-level associator = `IsIso (sheafification.map (η_P ▷ Q))`.
- **Route A** (`LocalizedMonoidal`): reduces (Day reflection) to `MonoidalClosed (PresheafOfModules R₀)` —
  search-CONFIRMED ABSENT. **Route B** (bespoke local-iso): needs `IsLocallyFreeOfRank` + `X.Modules`
  local-iso criterion (both absent) + forming `η_P ▷ Q` errors (`MonoidalCategoryStruct` synthesis bridge).
  **Route C** (generic IsIso): mathematically FALSE for non-locally-free `Q` (tensor right-exact only).
- iter-050 must build Route-A or Route-B infra first. Informal-agent unavailable (no LLM key).

## Review subagents
- **lean-auditor `iter049`** (0 must-fix / 0 critical / 0 major / 3 minor): both files clean; all 3 decls
  genuine + non-vacuous + axiom-clean; 10 private markings appropriate; `genericFlatness` sorry honest
  (counterexample-documented). Minors: iter-journal lines in proof bodies (FlatteningStratification);
  unexplained `@[reducible]` on `pullbackModuleAddEquiv`; `@[simp]` on `private` lemmas (SectionGradedRing).
  Report: `task_results/lean-auditor-iter049.md`.
- **lean-vs-blueprint-checker `flat-iter049`** (3 major, ALL blueprint-side; Lean correct): seam 1c blueprint
  (1) missing `\leanok`, (2) erroneous "quasi-coherent" qualification (Lean needs none), (3) absent typeclass
  hypotheses. Report: `task_results/lean-vs-blueprint-checker-flat-iter049.md`.
- **lean-vs-blueprint-checker `snap-iter049`** (0 red flags / 2 minor): `sectionsMul` exact match;
  `tensorPowAdd` correctly absent. Minors: `lem:sheafTensorPow_add` sketch omits Route-B's 3 absent
  primitives; namespacing inconsistency in future `\lean{}` hints. Report:
  `task_results/lean-vs-blueprint-checker-snap-iter049.md`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_finite_gen_iff_free_epi`: added `\leanok` (manual override —
  sync_leanok missed it; decl axiom-clean + green, confirmed by both review subagents + prover lean_verify).
- `Picard_FlatteningStratification.tex`, `lem:gf_finite_gen_iff_free_epi`: added `% NOTE:` flagging the
  quasi-coherence over-qualification + absent typeclass hypotheses (prose rewrite is the planner's domain).

## Key findings
- GF seam-1 collapses from 3 missing primitives to ONE (1a); 1a's blocker is now precisely characterized as
  the QUOT `overRestrictPullbackIso` epi-preservation bridge — a known multi-iter build, not an open search.
- SNAP `sectionsMul` is the last associator-free SNAP target; everything further (graded-ring assembly) is
  gated on the sheaf associator, whose two viable routes both rest on confirmed-absent Mathlib infra.

## Notes (LOW)
- 10 unmatched (private SNAP helpers) — see recommendations.
- blueprint-doctor iter-049: 0 findings.
