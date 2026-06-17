# Session 233 — review of iter-233

## Metadata

- **Iteration / session:** 233.
- **Mode:** parallel — **three prover lanes**, all status `done`.
- **Canonical sorry count:** the plan agent wired the previously-orphan `Cohomology/FlatBaseChange.lean`
  into the aggregator this iter (refactor `wire-flatbasechange`), taking canonical **81 → 83** (its 2
  honest engine sorries now counted). **No prover lane closed an existing canonical sorry.** Canonical
  exits iter-233 at **≈83** (iter-232 `meta.json` recorded 82 — a persistent ±1 counting nuance; iter-233
  `meta.json` is not finalized at review time). **16 iters (since iter-217) with no canonical-sorry
  elimination on the Picard critical path.**
- **Build:** GREEN. `FlatBaseChange.lean` `lake env lean` exit 0 (2 documented sorry warnings);
  `StalkTensor.lean` clean (0 sorry, 0 warnings); `HigherDirectImage.lean` clean (3 documented sorries).
- **Blueprint-doctor:** CLEAN (no orphan chapters, no broken refs/uses, no new axioms).
- **`sync_leanok` iter-233, sha `35e4721a`, +51 / −0**, 6 chapters touched. No `\leanok` on the unbuilt
  `stalkTensorIso` — no laundering.

## The defining tension

**Genuine forward motion on three fronts, but the critical-path counter rose and the actual target
of the lead lane (the d.2 iso) is still not built.**

- **Forward (verified):** the d.2 lane produced the project's **first concrete construction toward the
  varying-ring stalk–tensor commutation** — a bottleneck dodged for ~20 iters via the now-abandoned
  dual detour. The forward comparison map `stalkTensorDesc` is axiom-clean. Both engine lanes produced
  honestly-scoped, axiom-clean infrastructure (3 locality criteria; a conditional `higherDirectImage`
  def + 3 honest sorries).
- **The sting (three parts):**
  1. **The d.2 ISO — the blueprint target `stalkTensorIso` — does not exist.** Only the forward
     additive map landed. Reaching the iso needs `stalkTensorDescU_smul` (carrier-duality plumbing) →
     `R_x`-linear map → reverse map (nested colimit descent, ~150–250 LOC) → bundling. The iso is what
     unblocks `isLocallyInjective_whiskerLeft_of_W` → unconditional associator → `thm:pic_commgroup`.
     Multi-iter away.
  2. **The canonical counter went UP +2** (FlatBaseChange wiring) and no existing sorry closed. This is
     deliberate and honest (those 2 sorries were always real; now they are tracked), but the
     critical-path velocity is still 0/iter.
  3. **Two of the three new files are ORPHANS** — `StalkTensor.lean` and `HigherDirectImage.lean` are
     not imported by any module in the canonical closure, so their declarations and sorries are
     invisible to the build. The StalkTensor prover explicitly flagged the missing aggregator import.

This is not a knock on the provers (all three on-target, axiom-clean for what landed, honest sorries,
mathlib-build lanes pinned no sorry) nor the planner (the d.2 diagnosis is sound — both alternative
associator routes were correctly refuted, and the engine de-gating is real parallelism). It is the
honest read: motion is real but the lead lane has not yet reached its deliverable, and two outputs are
one import line away from mattering.

## Per-lane detail

### Lane 1 — `StalkTensor.lean` (d.2, mathlib-build) — PARTIAL

NEW file, **7 axiom-clean declarations** (`{propext, Classical.choice, Quot.sound}`):
`stalkTensorBilin`, `stalkTensorBilin_balanced`, `stalkTensorDescU`, `stalkTensorDescU_tmul`,
**`stalkTensorDesc`** (the forward map `(A⊗ᵖB).stalk x ⟶ A_x⊗_{R_x}B_x`, `colimit.desc` with full
cocone naturality discharged), `germ_stalkTensorDesc`, `stalkTensorDesc_germ_tmul`.

- **Reusable cocone-naturality recipe (validated):** bare `ext z` + `induction z using
  TensorProduct.induction_on`; the `tmul` case closes with
  `erw [tensorObj_map_tmul, stalkTensorDescU_tmul, stalkTensorDescU_tmul]; erw [germ_res_apply,
  germ_res_apply]; rfl`. `erw` is essential — `R` vs `R ⋙ forget₂` and PoM-map vs presheaf-map are
  defeq but not syntactic. `zero`/`add` cases need term-mode `(AddMonoidHom.map_zero _).trans …`
  (generic `map_zero`/`map_add` do not match the `AddCommGrpCat.Hom.hom` wrapper).
- **Blocker hit (next step):** `stalkTensorDescU_smul` (R_x-linearity) is blocked by the
  CommRingCat/RingCat **carrier duality**: with `r : ↑(R.obj (op U))` the tensor smul lemmas
  (`smul_tmul'`, `smul_zero`) fail to synthesize `DistribMulAction`/`SMulCommClass`; with the RingCat
  carrier they fire but `germ R r` no longer typechecks. Needs a small `RingEquiv`/`eqToHom` bridge.

### Lane 2 — `FlatBaseChange.lean` (engine, mathlib-build) — SOLVED (locality) / BLOCKED (engine theorems)

**3 axiom-clean locality criteria** for `Scheme.Modules` morphisms:
`isIso_iff_isIso_stalkFunctor_map` (stalk-local), `isIso_of_isIso_app_of_isBasis` (basis-local),
`isIso_iff_isIso_app_affineOpens` (affine-open). The first is wired into
`affineBaseChange_pushforward_iso`'s reduction (now reduces to affine opens, where the tilde dictionary
computes the section map). The 2 engine theorems remain honest sorries — blocked on the **Mathlib-absent
tilde pushforward/pullback dictionary** (~350–450 LOC; `cancelBaseChange` verified present and ready to
close the per-affine-open goal once the dictionary exists) and, for the flat theorem, Čech/affine-cover
infra. **Do NOT retry `TopCat.Sheaf.isIso_iff_isIso_basis`** — loogle reports it but it is ABSENT in the
pinned Mathlib; use the stalk route.

### Lane 3 — `HigherDirectImage.lean` (engine, prove) — SOLVED (def) / BLOCKED (3 lemmas)

NEW scaffold, 4 decls. `higherDirectImage := ((pushforward f).rightDerived i).obj F` compiles but is
**conditional on `[HasInjectiveResolutions X.Modules]`** — Mathlib has `Abelian X.Modules` but NOT
`EnoughInjectives`/`IsGrothendieckAbelian` for `SheafOfModules` over a sheaf of rings (only for
`Sheaf J A`, fixed value cat). The prover correctly carried the instance as an explicit hypothesis
rather than sorrying an `EnoughInjectives` instance (which would silently contaminate consumers). 3
honest sorries (quasi-coherence / affine vanishing / flat base change), each blocked on Mathlib-absent
infra (explicit `Rⁱf_*` description, relative Mayer–Vietoris, Čech-to-cohomology).

## Review subagents (all dispatched; **0 must-fix-this-iter** across all four)

- **lean-auditor** (`iter233`, 3 files): no must-fix. 2 **major** — `flatBaseChange_higherDirectImage_isIso`
  has `(i : ℕ)` with **no `1 ≤ i`** bound (contradicts docstring "i ≥ 1" + Stacks 02KH) and a
  `Nonempty (…≅…)` return type (cannot serve as the canonical natural transformation). Minor: blanket
  `import Mathlib` in all 3 files; workflow-era phrases in StalkTensor module docstring; verbose `add`-case
  in the cocone proof. Confirmed the StalkTensor cocone proof is a **genuine** computation, not a
  defeq-collapsed triviality. Report: `task_results/lean-auditor-iter233.md`.
- **lean-vs-blueprint-checker** (`stalktensor`): the pinned `stalkTensorIso` is a **managed absence** (NOTE
  accurate, no `\leanok`). Blueprint proof sketch **under-specified** for the 3 remaining iso steps
  (no mention of the carrier-duality obstacle, no reverse-map construction, directional asymmetry vs the
  Lean forward map). Recommends a `\lean{}` pin for `stalkTensorDesc` as machine-readable partial progress.
  Report: `task_results/lean-vs-blueprint-checker-stalktensor.md`.
- **lean-vs-blueprint-checker** (`higherdirectimage`): no must-fix; 3 **major** blueprint-documentation
  gaps — `[HasInjectiveResolutions]` recorded only on the def block (not the 3 downstream statements);
  the missing `1 ≤ i`; the `Nonempty` weakening (blueprint prose claims a *canonical* iso). Proof sketches
  otherwise adequate. Report: `task_results/lean-vs-blueprint-checker-higherdirectimage.md`.
- **lean-vs-blueprint-checker** (`flatbasechange`): no must-fix; 2 **major** — the 3 locality lemmas have
  **no `\lean{}` blocks** in the chapter (one is the literal first step of the affine proof); add a
  "Project-local locality criteria" supplement subsection + `\uses{}` tags. Engine theorem signatures are
  faithful. Report: `task_results/lean-vs-blueprint-checker-flatbasechange.md`.

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation`: added `% NOTE (iter-233)` recording
  that only the forward comparison map `stalkTensorDesc` is formalized; the pinned iso `stalkTensorIso`
  does not yet exist (block stays unmarked).
- `Cohomology_HigherDirectImage.tex`, `def:higher_direct_image`: added `% NOTE (iter-233)` recording the
  extra `[HasInjectiveResolutions X.Modules]` hypothesis (Mathlib-absent `EnoughInjectives` for
  `SheafOfModules`) and that the file is an unimported orphan.

(No `\leanok` touched — owned by the deterministic sync. No `\lean{}` rename corrections needed — the
prover did not rename a pinned decl; `stalkTensorIso` was simply not built this iter.)

## Recommendations

See `recommendations.md`. Headline: (1) **wire `StalkTensor.lean` into the aggregator — free, 0 sorries**,
makes the d.2 forward map enter the canonical build; (2) the d.2 next step (`stalkTensorDescU_smul` →
linear map → reverse map → iso) is the critical path to `pic_commgroup` and must not become a
helper-churn loop — the next round must land at least `stalkTensorLinearMap`; (3) fix
`flatBaseChange_higherDirectImage_isIso` (`1 ≤ i` + the `Nonempty` weakening); (4) blueprint-writer
follow-ups for the three "major" documentation gaps.
