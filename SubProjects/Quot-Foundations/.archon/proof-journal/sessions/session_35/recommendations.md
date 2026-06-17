# Recommendations for the next plan iteration (post iter-035)

## TL;DR
Two lanes advanced with axiom-clean content (QUOT gap1-D cover keystone; GR properness reduced to one
obligation). FBC-A's conjugate route is **exhausted** — its tripwire fired; iter-036 must pivot, not
re-assign. No must-fix-this-iter from any reviewer (lean-auditor + 3× lean-vs-blueprint-checker all clean
on the Lean; findings are blueprint coverage/accuracy + comment hygiene).

---

## 1. Closest-to-completion / highest-leverage targets

### GR-proper — build `ValuativeCriterion.Existence (toSpecZ d r)` (frontier, 1 obligation left)
`Grassmannian.isProper` is reduced to exactly ONE obligation via `isProper_of_valuativeExistence`
(axiom-clean this iter). The existence build is decomposed (Nitsure §1, in
`task_results/AlgebraicJacobian_Picard_GrassmannianCells.md`):
- **E1 — chart factorization [dispatch FIRST; it gates E2/E3/E4].** Factor `i₁ : Spec K → scheme d r`
  through an open-cover member `ι_I`. This is the **primary missing Mathlib API**. Before hand-rolling
  (topological point + `Scheme.Hom.appLE`/stalk), scout `Scheme.OpenCover` + `IsLocalRing` factorization /
  `Scheme.Hom.liftOpenCover`-style lemmas. Consider a `mathlib-analogist` (api-alignment) consult to find
  the idiom before a prover round.
- **E2 — minimal-valuation selection [medium].** `ValuationRing.valuation R K` + `Finset.max'` over the
  finite index; nonemptiness from `minorDet_self`.
- **E3 — entries land in R + factor g through R [partially supported].** Algebraic core
  `transitionPreMap_minorDet_mul` landed axiom-clean this iter; the residual is the entry-as-minor sign
  combinatorics (column-replacement determinant) — the one sub-step with no scaffold; build a standalone
  `private lemma` on `Matrix.det` of identity-with-one-column-replaced first.
- **E4 — lift construction + triangles [medium].** `Spec.map g' ≫ ι_J`; triangles via the E1 factorization
  + `specZIsTerminal.hom_ext`.
This is a fresh multi-piece phase — effort-break the existence statement (or dag-walk `sec:gr_proper`) and
blueprint E1–E4 before the first prover round.

### QUOT gap1 — build the `Hfr` slice→`Spec R_r` SECTION transport (closes gap1 in 2 one-liners)
gap1-D landed axiom-clean in cover form (`isLocalizedModule_basicOpen_descent_of_cover`). The NAMED
keystone `isLocalizedModule_basicOpen_descent` (quasi-coherent `M`) and gap1
(`isIso_fromTildeΓ_of_isQuasicoherent`) are gated solely on producing `Hfr`: the section-level transport
`Γ((pullback (Opens.ι (q.X i))).obj M, ⊤) ≅ Γ(M, q.X i)` intertwining restriction maps. This is the
**section-level analogue of P1's object-level transport** (same Mathlib-absent open-immersion-pullback vs
presheaf-restriction comparison). Needs a dedicated lane — likely a refactor/dag-walker pass to establish
the comparison iso + its naturality, then chain through P1's two pullbacks. Once landed, both targets are
one-liners (recipe in `task_results/AlgebraicJacobian_Picard_QuotScheme.md`).

---

## 2. Blocked — do NOT re-assign without a structural change

### FBC-A `_legs` / conj-2a — conjugate route EXHAUSTED; tripwire FIRED → pivot iter-036
The "last authorized conjugate round" ran. It atomized the `_legs` obstruction (7 axiom-clean decls;
`_legs` is a sorry-free wrapper) but closed **nothing axiom-clean on the crux** — the residual sorry only
MOVED into conj-2a (`base_change_mate_fstar_reindex_legs_conj`; `_legs` transitively sorry-backed,
`lean_verify` sorryAx). The blocker is the section-composite→`conjugateEquiv`-component reframing, a
multi-iter stall the explicit-factor/section vehicle cannot express (NOT a missing Mathlib lemma).
**iter-036 must execute the pre-scheduled affine-local explicit-inverse + element-`ext` refactor (STRATEGY
Open Q2 fallback / PROGRESS Iter-036 ramp). Do NOT dispatch any conjugate/section prove round on `_legs`
or conj-2a.** This is the route's 6th iter at sorry=4. The conjugate scaffolding (conj-1a/1b/2c + param
helpers) is route-independent proven content and should survive the pivot. `gstar_transpose` @2122 is the
SECOND independent FBC sorry on the same crux (per lean-auditor) — do not assign in isolation; it follows
once `_legs` closes.

### GF (FlatteningStratification) — 1 sorry, still gated on gap1
Untouched this iter (correctly — it consumes the gap1 keystone). Unblocked only after the QUOT `Hfr`
transport above lands.

---

## 3. Blueprint coverage / accuracy actions (from reviewers — NONE must-fix, but do before iter-036)

### MAJOR — blueprint registration gaps (planner must add blocks; review agent does not author prose)
- **QUOT (lvb-quot):** `isLocalizedModule_basicOpen_descent_of_cover` (public, axiom-clean, the iter-035
  keystone) has NO `\lean{}` block. The existing `% NOTE (iter-035)` at `lem:section_localization_descent`
  (Picard_QuotScheme.tex L3551) instructs: add a dedicated `lem:section_localization_descent_of_cover`
  block pinning it, keep the named-form block as a future target. Do this — it blocks `\leanok`
  propagation + DAG tracking for the most significant theorem landed this iter.
- **GR (lvb-gr):** all 7 new properness-scaffold decls are absent from `sec:gr_proper`
  (`compactSpace_scheme`, `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`, `quasiSeparated_toSpecZ`,
  `valuativeUniqueness_toSpecZ`, `transitionPreMap_minorDet_mul`, `isProper_of_valuativeExistence`).
  Dispatch a blueprint-writer for `sec:gr_proper` (the prover's `task_results` has the per-decl `\uses`
  table to seed it).
- **FBC (lvb-fbc):** `lem:base_change_mate_codomain_read_legs` prose/title/`\uses` describe the CONJUGATE
  form but the `\lean{}` pins the `pullbackComp` (non-conj) decl. A review `% NOTE` was added flagging
  this. Planner fix: either repoint the pin to `..._conj`, or revert the prose to the variable-legs
  `pullbackComp` form; and MOVE `lem:leftAdjointCompIso_mathlib` +
  `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` from this `\uses` to the `_conj` block's `\uses`.
  The graph is misleading for iter-036 planning until fixed.

### MAJOR — lean-auditor comment hygiene (FlatBaseChange.lean)
- L1693: a proof comment references `PROGRESS.md` by name ("PROGRESS.md tripwire"). `.lean` proof bodies
  should be self-contained — replace with a standalone explanation (no project-management terms).
- L184–247: historical narrative comment block cites stale iter numbers (iter-234/236/240/241). Replace
  with mathematical descriptions of what was resolved.
- L2122 `gstar_transpose` is a SECOND independent sorry site; track separately from conj-2a (the "single
  residual FBC sorry" framing is true only of the `_legs` chain, not the file — the file has 4 sorries:
  conj-2a @1700, gstar_transpose @2122, affine @2303, FBC-B target @2325).

### 1-to-1 coverage debt — `archon dag-query unmatched` = 21 lean_aux nodes (planner: blueprint each)
New this iter (need blocks):
- GR (7): `compactSpace_scheme`, `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`,
  `quasiSeparated_toSpecZ`, `valuativeUniqueness_toSpecZ`, `transitionPreMap_minorDet_mul`,
  `isProper_of_valuativeExistence` (deps: `task_results/AlgebraicJacobian_Picard_GrassmannianCells.md`).
- QUOT (1 public + 5 private): `isLocalizedModule_basicOpen_descent_of_cover` (public — needs a block);
  `descent_overlap_agree`, `descent_smul_eq_zero`, `descent_surj`, `iSup_basicOpen_subtype_eq_top`,
  `res_comp` (private — owe no block by convention, but listing for completeness).
- FBC (4): `base_change_mate_codomain_read_legs_eq_param`, `base_change_mate_codomain_read_legs_param`,
  `conjPullbackFactor`, `conjPullbackFactor_eq_pullbackComp` (coverage debt; lvb-fbc minor).
Pre-existing (older, still unmatched): GR `rotMid`, `transitionInvImageMatrix`, `transitionInvPair`;
QUOT `isIso_unitToPushforwardObjUnit_of_isIso'`. (Private helpers — convention is no block; the public
ones above are the real debt.)

### MINOR (no action forced this iter)
- QUOT `thm:grassmannian_representable`: signature is a bare existence skeleton vs the prose's
  smooth-projective/relative-dim/tautological-quotient/Plücker claims — pre-existing, self-documented
  (NOTE L4112–4116). Defer under the "never weaken the type to dodge the proof" rule.
- 9 GR + 2 QUOT `\lean{}` pins target `private` decls (inaccessible externally) — documented; a future
  refactor could `protected` them or add public aliases.
- FBC `lem:gammaMap_pushforwardCongr_hom`: blueprint says "identity morphism"; Lean gives `eqToHom (by rw
  [hfg])` (more precise) — sharpen the prose.
- FBC three `set_option maxHeartbeats 4000000` theorems (≈8× default) — legitimate; profile for
  compression once the sorries close.

---

## 4. Reusable proof patterns discovered this iter (also in PROJECT_STATUS Knowledge Base)
- **gap1-D descent in COVER form via sheaf-gluing, NOT the affine equivalence** — assemble the 3
  `IsLocalizedModule` fields directly (`existsUnique_gluing'` / `eq_of_locally_eq'` / per-cover
  `exists_of_eq`); never route through `QCoh ≃ Mod`. Field is `surj` (not `surj'`).
- **ModuleCat sheaf-restriction proofs must be TERM-MODE** — `rw` fails on the `ModuleCat.Hom.hom
  (presheaf.map (homOfLE ⋯).op)` coercion (elided proofs defeat `rw`); use `congrArg`/`.trans`/fully-applied
  `LinearMap.map_smul`/`res_comp` with explicit opens.
- **GR properness cheap-3 via the valuative criterion** — `compactSpace` via `openCover.compactSpace` (use
  explicit `Spec (CommRingCat.of (MvPolynomial …))`, not the `affineChart` shim); LOFT via `exact
  (HasRingHomProperty.Spec_iff …).mpr (RingHom.finiteType_algebraMap.mpr inferInstance)` (NOT `rw`);
  uniqueness FREE from separatedness.
- **FBC conjugate atomization device** (param-then-`rfl`, `conjPullbackFactor`, `change` not `show`) —
  isolates the obstruction into a named identity but does NOT close it; recorded so the next iter does not
  mistake "atomized" for "progress on the crux."
