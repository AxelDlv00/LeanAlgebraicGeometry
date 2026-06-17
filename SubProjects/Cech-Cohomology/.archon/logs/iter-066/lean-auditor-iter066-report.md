# Lean Audit Report

## Slug
iter066

## Iteration
066

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **CLEAN — zero `sorry`/`admit` in entire file.** Both `higherDirectImage_openImmersion_acyclic` and `higherDirectImage_openImmersion_comp` are sorry-free.
  - **`hacyc` closure (lines 973–986) is GENUINE.** The route is: `unfold Scheme.Modules.restrictFunctor` + `inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint` establishes that `restrictFunctor j` has a left adjoint (it *is* the sheaf pushforward, which is a right adjoint to the pullback `j_!`). Then `Injective.injective_of_adjoint (restrictAdjunction j) Iⁿ` uses the adjunction `restrictFunctor j ⊣ pushforward j` (the `j^* ⊣ j_*` adjunction): since `restrictFunctor j` (the left part here) preserves monomorphisms (it is itself a right adjoint to `j_!`), the right part `pushforward j` preserves injective objects. The `infer_instance` conclusion (`IsRightAcyclic`) is honest. No vacuous collapse.
  - **`eRes` (lines 992–999):** Three-iso chain — `gCosyzygyIsoCocycles`, `singleObjHomologySelfIso`, `isoOfQuasiIsoAt`, `isoHomologyπ₀` — all genuine Lean lemmas. Clean.
  - **`hexact` (lines 1001–1007):** Calls `higherDirectImage_openImmersion_acyclic` (which is sorry-free). Iso transport via `isoRightDerivedObj`. Clean.
  - **`transport` (lines 1008–1016):** Uses `NatIso.mapHomologicalComplex (pushforwardComp j f)` — no collapse, correct LHS is definitionally equal. Clean.
  - **Stale comment (major) — lines 877–896:** Inside `higherDirectImage_openImmersion_acyclic` the block says "The three remaining geometric facts are the only unbuilt pieces: `hV'` / `hjt` / `hqc`" and "`hjt`/`hqc` are the two remaining geometric transport sub-lemmas." All three are immediately closed inline below (lines 891–900: `case hV'`, `case hjt`, `case hqc`). The word "remaining" and "unbuilt" are false; the comment is a surviving planning note from a previous iteration.
  - **Stale comment (major) — lines 956–966:** Inside `higherDirectImage_openImmersion_comp`, the block says "RESIDUAL (genuine cohomological gaps, handed off — each depends on Part (1)'s residual): (a) … (b) …". Both (a) and (b) are proved immediately below in `case hexact` and `case hacyc`. Additionally the description of (b)'s proof strategy is **wrong**: the comment says to use "the same Serre-vanishing argument on the affine `U ∩ f⁻¹V`" but the actual `hacyc` proof uses `Injective.injective_of_adjoint` (the adjoint route, not Serre vanishing). This misrepresents what the proof does.
  - **Stale comment (minor) — lines 605–623:** Block comment labelled "RESIDUAL STATE (iter-065 — the keystone φ'' and the whole slice cascade are CLOSED)." The iter-065 label is historical; it is not wrong but gives the reader the impression the code was not yet completed as of the present audit.
  - **`Subsingleton.elim` uses (lines 647, 681, 921, 746–750):** All on morphisms in the opens poset or elements of a provably-zero group. Not kernel-soundness traps — the goals are provably trivial.
  - **Heartbeat bumps:** Documented with clear explanations (slow instance synthesis for sliced sites). Not a bad practice here.

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none (planner-strategy blocks are acknowledged planning text, not misleading status claims)
- **suspect definitions**: none
- **dead-end proofs**: none (open sorries are honestly typed)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Stubs 1–4 sorry-free (confirmed):** `cechBackbone_left_sigma` (line 619), `pushPull_sigma_iso` (line 1234), `pushPull_leg_sections` (line 1279), `pushPull_eval_prod_iso` (line 1328) — all compile without `sorry`.
  - **`mapHC_augment_iso` (lines 1374–1390): CLEAN.** Uses `HomologicalComplex.Hom.isoOfComponents` with all components `Iso.refl _`; differential commutativity closed by `simp [CochainComplex.augment]` for both degree-0 and degree-n+1 cases. The proof is justified: applying a functor commutes with augmentation at the identity level.
  - **`map_augment_cond` (lines 1394–1400): CLEAN.** Three-line proof: `haveI := hΦ; change …; rw [← Functor.map_comp, w, Φ.map_zero]`. Exactly the right chain.
  - **`augmentCochainIso` (lines 1405–1418): CLEAN.** The `i = 0` case uses `hcompat.symm` (the supplied compatibility square). The `n+1` case uses `simp only [CochainComplex.augment_d_succ_succ]` (which reduces the augmented differential at degree ≥ 2 to the base complex differential) then `φ.hom.comm n (n+1)`. The indexing is correct: degree-0 of the augmented complex = augmentation object (component `eY`); degree-`n+1` of the augmented complex = degree-`n` of the base (component `isoApp φ n`).
  - **`eY` closed by `Iso.refl _` (line 1496–1498): HONEST.** The adapter `GV.obj (forget ⋙ restrictScalars (𝟙 ·)).obj F)` is definitionally equal to `Fp.presheaf.obj (op V)` when `α = 𝟙` (both `restrictScalars (𝟙 ·)` and `toPresheaf` are transparent on the underlying abelian-group presheaf). This is correct; `Iso.refl _` is not hiding nontrivial content.
  - **`coreIso` sorry (line 1492): Honest open.** Type is the genuine non-augmented degreewise iso between the doubly-evaluated Čech complex and `sectionCechComplexV`. Requires differential match via `sectionCech_objD_apply`. Not weakened.
  - **`hcompat` sorry (line 1504): Honest open.** Type is the compatibility square at degree 0, depending on `coreIso`. Also depends on the sorry'd `coreIso` (sorry-propagation, expected). When `coreIso` is filled, `hcompat` becomes the degree-0 component of the same proof obligation.
  - **`cechSection_contractible` sorry (line 1585): Honest open.** The return type `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` is the full contracting homotopy statement; not weakened. The planner strategy comment is detailed and sound (Dependent-engine route via `depHomotopy`/`depHomotopy_spec`).
  - **Minor — header comment lines 35–38:** The status comment says "the lone residual is the non-augmented degreewise iso + differential match (`coreIso`, plus its degree-0 augmentation-compat instance `hcompat`)". Using "lone residual" while then listing two named items (`coreIso` and `hcompat`) is slightly imprecise; both are separate `sorry`s in the code. The comment does name both, so it is not factually wrong.

---

## Must-fix-this-iter

None.

No unauthorized axioms, no weakened-wrong definitions, no excuse-comments, no sorry on a load-bearing claim not acknowledged as open.

---

## Major

- `OpenImmersionPushforward.lean:877–896` — Stale "RESIDUAL" comment inside `higherDirectImage_openImmersion_acyclic` labels `hjt`/`hqc` as "remaining" and "unbuilt" geometric sub-lemmas, while both are proved inline immediately below (`case hjt` at line 892, `case hqc` at line 900). The word "remaining" is factually false in the current code state.

- `OpenImmersionPushforward.lean:956–966` — Stale "RESIDUAL (genuine cohomological gaps, handed off)" comment inside `higherDirectImage_openImmersion_comp` labels (a) exactness and (b) acyclicity as gaps "handed off", while both are proved inline (`case hexact` and `case hacyc`). Additionally the comment's description of (b)'s proof strategy is wrong: it says "the same Serre-vanishing argument on the affine `U ∩ f⁻¹V`" but the actual `hacyc` proof uses the adjoint-preservation route (`Injective.injective_of_adjoint`), not a Serre-vanishing presheaf argument.

---

## Minor

- `OpenImmersionPushforward.lean:605–623` — Historical block comment "RESIDUAL STATE (iter-065 — the keystone φ'' and the whole slice cascade are CLOSED)" is accurate about what was done in iter-065 but the iter-number reference and framing as a residual-state block may confuse readers about the current state of the proof. Not misleading about correctness, just historical noise.

- `CechSectionIdentification.lean:35–38` — Header status comment uses "lone residual" for a situation that has two separate `sorry`s (`coreIso` and `hcompat`). The comment names both by identifier, so it is not incorrect, but "lone" is potentially confusing.

---

## Excuse-comments (always called out separately)

None found. No `-- TODO`, `-- placeholder`, `-- temporary`, `-- will fix`, or `-- wrong but` comments anywhere in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 2
- **excuse-comments**: 0 (none found)

Overall verdict: Both files are mathematically sound with zero unauthorized sorries; `higherDirectImage_openImmersion_comp` is genuinely closed (no shortcuts, hacyc adjoint route is correct); the two major findings are stale planning-note comments that misdescribe the proof state or proof strategy, and should be cleaned up to prevent confusion for future readers.
