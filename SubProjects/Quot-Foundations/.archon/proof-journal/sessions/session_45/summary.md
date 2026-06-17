# Session 45 (iter-045) — Review Summary

## Metadata
- **Build:** GREEN. Both prover-touched files compile; `lake build` errors 0 (style / long-line /
  `maxHeartbeats`-comment / `local instance` lints only).
- **Sorry count per touched file:** FlatBaseChange.lean **4 → 4** (keystone `_legs_conj` @1949,
  `gstar_transpose` @2416, FBC-A2 @2597, FBC-B @2619); FlatteningStratification.lean **1 → 1**
  (`genericFlatness` @2371). **Net 0 new sorry; +4 axiom-clean non-private defs.**
- **Targets attempted:** 2 lanes — FBC keystone `base_change_mate_fstar_reindex_legs_conj`;
  GF-G1 `gf_qcoh_fintype_finite_sections`.
- **All 4 new decls** `#print axioms` = `{propext, Classical.choice, Quot.sound}` (re-confirmed by
  lean-auditor). blueprint-doctor: **0 findings**. sync_leanok (iter 45, sha 5808d08): **+1 / -0**
  (Picard_QuotScheme only). leandag: gaps=0, frontier=8, **unmatched=4** (the 4 new defs).

## Target 1 — FBC `base_change_mate_fstar_reindex_legs_conj` (FlatBaseChange.lean) — PARTIAL → PARKED
The 8-iter wall (037–044) was fundamentally the uncertainty *"can the depth-≥2 conjugate pair
`adjL`/`adjR` and a NON-monolithic comparison `β` even be assembled, and is the pair conjugate-
comparable?"* **This iter RESOLVED that in Lean** (+2 axiom-clean defs):

- **`keystoneAdjR` (L1755)** — `(extendRestrictScalarsAdj inclA.hom).comp ((tilde.adjunction (R:=A⊗R')).comp
  (pullbackPushforwardAdjunction e.hom))`. `conjugateEquiv adjL (keystoneAdjR ψ φ)` typechecks → the
  conjugate pair `(adjL, adjR)` is well-formed (same `C=ModuleCat A`, `D=pullback.Modules`).
- **`keystoneBeta` (L1772)** — `isoWhiskerRight (pushforwardComp e.hom (Spec inclA)).symm Γ_A ≪≫ associator
  ≪≫ isoWhiskerLeft (pushforward e.hom) (gammaPushforwardNatIso inclA) ≪≫ associator.symm`. Built ONLY
  from conj-2c (`pushforwardComp`) + conj-2d (`gammaPushforwardNatIso inclA`) — no bespoke depth-5 nat-iso.
- **In-proof `huce`** — `unit_conjugateEquiv_symm adjL (keystoneAdjR ψ φ) keystoneBeta.hom M` typechecks,
  giving the A-level coherence `adjL.unit ≫ β.hom = adjR.unit ≫ R₂.map((conjEquiv).symm β.hom)`.

**Keystone NOT closed (sorry @1949).** Precise residual: the goal lives over **`R`** (`Γ_R`,
`pushforward (Spec φ)`), NOT over `A`; the A-level conjugate core is wrapped by TWO absorbed Spec-layers —
front `(gammaPushforwardTildeIso φ M).inv` (φ-layer) and end `gammaPushforwardIso ψ … ≪≫ restrictScalars ψ
.mapIso(read_param … conjPullbackFactor)` (ψ-layer + 6-iso read), bridged by the ring equation
`inclA·φ = inclR'·ψ`. The close is a two-stage transport replaying conj-2d's `hClaimA`/`hgPTI`/`hβapp`
**twice** (φ + ψ) plus the bridge — multi-hundred-LOC, structurally KNOWN, NOT an open search.
**PARKED per the armed kill-criterion** (no second reprieve); FBC is off the critical path (QUOT/GF/GR
have no dependency). Attempts: see `milestones.jsonl` target 1.

## Target 2 — GF-G1 `gf_qcoh_fintype_finite_sections` (FlatteningStratification.lean) — PARTIAL
Locality half DONE (+2 axiom-clean defs); full form blocked on the finite-type base case.

- **import added:** `AlgebraicJacobian.Picard.QuotScheme` — first cross-leaf import, acyclic (QuotScheme
  imports only Mathlib), full build GREEN ~95s. Consumes the iter-044 gap2 keystone.
- **`finite_localizedModule_of_isLocalizedModule` (L2173)** — model-independence of localized-module
  finiteness: `e := IsLocalizedModule.linearEquiv`, `ψ := IsLocalization.algEquiv`, prove `e` is
  `ψ`-semilinear (clear denominator via `Module.End.isUnit_iff` + `IsLocalization.mk'_spec` +
  `IsScalarTower.algebraMap_smul`), transport spanning set by `Submodule.span_induction`. Project-local
  because Mathlib's `Module.Finite.of_isLocalizedModule` needs GLOBAL `Module.Finite R M`.
- **`gf_finite_sections_of_basicOpen_finite_cover` (L2231)** — the **locality reduction** of G1
  (Stacks 01PB): `Module.Finite.of_localizationSpan_finite t ht`; per `g`: local `letI` compHom
  `Γ(X,W)`-module + scalar-tower, `hW.isLocalization_basicOpen g`, the gap2 keystone
  `isLocalizedModule_basicOpen`, then `finite_localizedModule_of_isLocalizedModule`.

**Full form `gf_qcoh_fintype_finite_sections` NOT added.** Blocked on the **finite-type base case**: the
Mathlib-absent bridge *`SheafOfModules.IsFiniteType` generating-sections epi ⟹ module-level surjectivity
on affine global sections* (`Γ(X,V)^I → Γ(F,V)` surjective via stalkwise surjectivity + stalk = localized
module). `leansearch`/`loogle` confirm Mathlib has only the abstract `IsFiniteType`/`LocalGeneratorsData`/
`GeneratingSections` predicates, no Γ-level corollary. Multi-piece geometric build; mathlib-build forbids
a typed sorry → left ABSENT and flagged. `genericFlatness` @2371 stays blocked on this. Attempts: see
`milestones.jsonl` target 2.

## Key findings / patterns discovered
- **Non-monolithic comparison nat-iso beats monolithic.** `keystoneBeta` assembled from existing conj-2c/2d
  legs via `isoWhiskerRight/Left` + `associator` — avoids the 7-iter monolithic-depth-5-β trap. The
  "build adjR/β as standalone axiom-clean defs, then `conjugateEquiv adjL adjR` typechecks" recipe is the
  right discipline for composite-adjunction conjugate recognition.
- **Local `letI`/`haveI` compHom module per basic open — never global.** A global
  `instance : Module Γ(X,U) Γ(F, X.basicOpen f)` via `Module.compHom` LOOPS (head unifies
  `U := X.basicOpen f`, recurses on the same goal). Keep compHom module + scalar-tower local.
- **Model-independence of localized-module finiteness is project-local.** No Mathlib transfer between two
  localized MODELS exists (`Module.Finite.of_isLocalizedModule` is global→local only). Built via
  `linearEquiv` (module side) + `algEquiv` (ring side) + semilinearity.

## Subagent dispositions (this review phase)
- **lean-auditor `quot-iter045`** (8 files; 9 must-fix / 2 major / 5 minor): **clean iter.** All 4 new decls
  genuine + non-vacuous + axiom-clean; the `letI`/`haveI` compHom + `IsScalarTower` pattern sound; new
  QuotScheme import acyclic; **0 excuse-comments project-wide**, 0 stale docstrings on new code. The 9
  "must-fix" are ALL pre-existing tracked sorry obligations (4 FBC sorries, `genericFlatness`, 4 QuotScheme
  protected scaffold stubs) — none new this iter. Majors/minors → recommendations §3. Report:
  `logs/iter-045/lean-auditor-quot-iter045-report.md`.
- **lvb-checker `fbc-iter045`** (0 must-fix / 2 major): Lean faithfully follows blueprint for all 48
  verified decls; majors = `keystoneAdjR`/`keystoneBeta` need blueprint blocks + the `_legs_conj` sketch is
  under-specified for the two-stage assembly → recommendations §1. Report:
  `logs/iter-045/lean-vs-blueprint-checker-fbc-iter045-report.md`.
- **lvb-checker `flat-iter045`** (0 must-fix / 2 major): faithful for all 43 decls, 0 red flags; majors =
  `finite_localizedModule_of_isLocalizedModule`/`gf_finite_sections_of_basicOpen_finite_cover` need
  blueprint blocks + G1 should be split into "locality reduction" (done) + "finite-type base case" →
  recommendations §1–2. Report: `logs/iter-045/lean-vs-blueprint-checker-flat-iter045-report.md`.

## Notes (LOW)
- Stale iteration numbering in docstrings (`iter-177+`, `iter-176`, `iter-174+`) carried from the original
  Algebraic-Jacobian-Challenge repo — confusing relative to this extracted project (iter-045). Cosmetic, no
  mathematical harm; cleanup is optional (recommendations §3).

## Blueprint markers updated (manual)
- None. No `\mathlibok` candidates this iter (the 4 new defs are project-local, not Mathlib re-exports); no
  rename/`\lean{}` corrections (prover-chosen names match the suggested blueprint labels); no stale
  `\notready` on landed blocks; sync_leanok (+1) already handled `\leanok`. The 4 new defs have NO blueprint
  block yet — that is coverage debt for the planner (recommendations §1), not a marker I can author (review
  agent does not write informal prose).
