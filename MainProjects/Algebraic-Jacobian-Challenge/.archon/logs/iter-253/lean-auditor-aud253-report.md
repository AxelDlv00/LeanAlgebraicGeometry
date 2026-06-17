# Lean Audit Report

## Slug
aud253

## Iteration
253

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Sorry count: 3 term-level sorries** at lines 708, 1962, 2027.
  - **L708 — `exists_tensorObj_inverse`**: The main inverse-of-line-bundle sorry. Body comment accurately explains the two remaining bridges (C: `dual_isLocallyTrivial`, A: `homOfLocalCompat`). The sorry is tracked and acknowledged.
  - **L1962 — `sheafifyTensorUnitIso_hom_natural`**: Helper for D1′. Comment at L1940–1961 documents a genuine Lean obstacle: the `erw` whisker calculus must bridge two defeq-but-distinct monoidal instances, causing catastrophic `whnf` even at 6.4M heartbeats. Proof is "mathematically complete" but unterminating. Sorry is honest; `set_option maxHeartbeats 1600000 in` is scoped.
  - **L2027 — `pullbackTensorMap_natural`** (D1′): After Square 1 is closed via `erw` naturality, Square 2 is blocked by a `Functor.comp_map` carrier mismatch: `sheafification (𝟙 Y.ringCatSheaf.obj)` vs `sheafification (𝟙 (Sheaf.val Y.ringCatSheaf))`. `dsimp only [Sheaf.val]` runs but leaves the two normal forms still distinct; `rw [← Functor.map_comp]` and `erw` both fail to unify. Comment at L2006–2026 is an accurate technical diagnosis, not an excuse. `set_option maxHeartbeats 3200000 in` is scoped.
  - **Module header sorry count (L43–44)**: Header says "THREE tracked typed-sorry residuals (iter-252)". Actual count is 3 (**correct**). The "(iter-252)" label is **stale** (we're in iter-253), though not misleading. The line-number reference "~L699" for `exists_tensorObj_inverse` is off by ~9 lines (actual: L708).
  - **D2′ CLOSED claim** (L47–61): Verified correct. `pullbackTensorMap_unit_isIso` (L1844–1848) has no sorry; `pullbackEtaUnitSquare` (L1746–1838), `isIso_sheafifyEta_of_unitSquare`, `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`, and `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` are all sorry-free. No stale CLOSED label.
  - **Dead code — `PullbackLanDecomposition` section** (L1244–1306): Explicitly labeled "OFF-PATH (iter-243 pivot)" in comment at L1238–1243. Five declarations (`pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition`) are axiom-clean and correct, but unreachable from the critical path. The comment says "do NOT extend it toward the general build." Documented dead code, not active harm.
  - **`set_option maxHeartbeats` inflated**: Scoped with `in` at L1694 (1.6M), L1736 (3.2M), L1872 (1.6M), L1909 (1.6M), L1967 (3.2M). All are documented with detailed explanations of why the default budget is insufficient (sheafification-laden composites in `erw`). Fragile but the cause is understood.
  - **`set_option backward.isDefEq.respectTransparency false in`** at L1657: Unusual global kernel option scoped to `epsilonPresheafToSheafUnit`. No comment explaining why it's needed. Could silently affect elaboration behavior if the option interacts with other parts of the proof.
  - **Extensive `erw`** throughout (e.g., L976–989, L1771, L1786–1789, L1836–1838, L1886–1901, L1937–1938, L1999, L2018–2022 in comments): Documented as necessary for defeq-but-not-syntactic bridging. Fragile pattern but correctly diagnosed and consistently motivated.
  - No unauthorized `axiom` declarations.
  - No excuse-comments ("temporary", "placeholder", "will fix later", etc.).

---

### `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Sorry count: 3 term-level sorries** at lines 256, 565, 581.
  - **L256 — `dual_restrict_iso`** Step 4: The residual presheaf goal `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` (pushforward along a ring iso commutes with the presheaf dual). Comment at L254–256 is honest. Steps 1–3 + H1 are in place and correct; Step 4 is a genuine new build deferred.
  - **L565 — `homOfLocalCompat` hcompat sorry (STRUCTURAL BLOCKER)**: `hf` is typed as `HEq` between `(Scheme.Modules.pullback (resLE …)).map (f i)` and `(Scheme.Modules.pullback (resLE …)).map (f j)`. The source/target objects of these morphisms — `(pullback (resLE …)).obj (M.restrict (U i).ι)` vs `(pullback (resLE …)).obj (M.restrict (U j).ι)` — are NOT propositionally equal (they are sheafifications of pullback presheaves along different maps, only isomorphic, not defeq). Consequently every standard HEq-elimination tactic (`eq_of_heq`, `conj_eqToHom_iff_heq`, `HEq.elim`, `subst`) requires the object equalities that do not hold. The comment at L547–564 correctly and in detail diagnoses this. The sorry at L565 **cannot be filled without changing the `hf` signature** in `homOfLocalCompat`. Since `homOfLocalCompat` has a protected signature (confirmed by the memory record and the comment "needs the mathematician — `hf` is in the PROTECTED signature"), prover agents are blocked. This is a **structural mismatch between the signature and the proof strategy**, not a hard but solvable proof obligation.
  - **L581 — `homOfLocalCompat` linearity sorry**: Explicitly documented as "TRANSITIVELY GATED on (a)" — i.e., the glued section `(hglue hcompat).choose` does not exist until `hcompat` (L565) is resolved. The linearity argument itself is described as independent and correct in principle. This sorry cannot be addressed until L565 is resolved.
  - **Module header sorry counts**: The header (L18–32) correctly flags `dual_restrict_iso` as PARTIAL (1 sorry ✓) and `dual_isLocallyTrivial` as TRANSITIVELY PARTIAL (correct — no own sorry, inherits from `dual_restrict_iso` ✓). The `homOfLocalCompat` entry says "**OPEN** (`sorry`)" with a singular "sorry" — the actual body has **2 sorries** (L565, L581). Minor discrepancy.
  - **`iter-251` label on `dual_restrict_iso`** (header L17–22): Stale. New declarations (`homLocalSection`, `topSectionToHom`, `topSectionToHom_app`) were added in iter-252/253, but the sorry in `dual_restrict_iso` itself is unchanged. The label is stale but non-misleading.
  - **`topSectionToHom` (L412–420)**: Non-vacuous, correctly stated. Converts a `presheafHom` section over `op ⊤` to a global morphism via `presheafHomSectionsEquiv`. Body uses `(presheafHom F G).map (homOfLE le_top).op s` to build the compatible family. Correct.
  - **`topSectionToHom_app` (L425–430)**: Correctly states the sectionwise computation: `(topSectionToHom s).app W = s.app (op (Over.mk (homOfLE le_top)))`. Body uses `presheafHom_map_app_op_mk_id`. Not vacuous.
  - **`homLocalSection` (L355–404)**: Non-vacuous. The `app` field correctly builds the `eqToHom`-conjugated section from `(f i).val.app`. The `naturality` field uses `Subsingleton.elim` twice for the two thin-poset diagram edges — correct for `Opens X` (which is a thin poset, so all parallel arrows are equal). The `hML`/`hNR` steps that extract the restrict-vs-eqToHom commutativity are correctly derived from `M.val.presheaf.map_comp`.
  - **`hcompat` structure in `homOfLocalCompat` (L529–565)**: The construction of `H`, `hsup`, and the `existsUnique_gluing` call are all correctly structured. The `erw [presheafHom_map_app ...]` and `simp only [homLocalSection]` unwrapping at L535–541 are on target. The `sorry` is at the correct remaining obligation. The proof strategy is sound modulo the `hf` signature problem.
  - **Large planner-strategy comment blocks embedded in docstrings** (L161–229, L286–331, L451–499): These multi-paragraph `/- Planner strategy: ... -/` blocks are inside the outer `/-- ... -/` docstrings. Valid Lean but creates very large docstrings and will show up verbatim in documentation. Not a correctness issue, but unusual and clutters the API docs.
  - No unauthorized `axiom` declarations.
  - No excuse-comments.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:708` — `exists_tensorObj_inverse := sorry`. Load-bearing A-bridge consumer; blocked on `dual_isLocallyTrivial` (C) and `homOfLocalCompat` (A). Why must-fix: sorry on a load-bearing lemma is the project's main open obligation; the downstream `addCommGroup` instance in `RelPicFunctor.lean` depends on it.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1962` — `sheafifyTensorUnitIso_hom_natural` sorry. Blocks D1′ (`pullbackTensorMap_natural`). Why must-fix: sorry on a load-bearing helper; the carrier-merge obstacle (two monoidal `≫` spellings that `erw` cannot bridge without `whnf`-explosion) needs a new approach (uniform-instance helper or `congr`-free route).

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2027` — `pullbackTensorMap_natural` (D1′) sorry. Gated on L1962. Why must-fix: sorry on load-bearing D1′ lemma; cannot close until `sheafifyTensorUnitIso_hom_natural` is resolved.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:256` — `dual_restrict_iso` Step-4 sorry. The presheaf goal `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` needs a new "pushforward along ring-iso commutes with internal hom" build via `restrictScalarsRingIsoDualEquiv`. Why must-fix: sorry on load-bearing C-bridge; `dual_isLocallyTrivial` and `exists_tensorObj_inverse` are transitively blocked.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:565` — `homOfLocalCompat` `hcompat` sorry. **CRITICAL STRUCTURAL MISMATCH**: the `hf : HEq (pullback(resLE…).map(f i)) (pullback(resLE…).map(f j))` hypothesis cannot be consumed because the source/target objects of the two morphisms are not propositionally equal (sheafifications of pullback presheaves along different morphisms). No standard HEq-elimination tactic can produce an equality in the fixed `Ab` hom-type needed by the `presheafHom` compatibility goal. The sorry cannot be filled without rephrasing `hf` — either sectionwise (as a family of equalities in the fixed section type) or via explicit `restrictFunctor`/`eqToHom` transport to the common `M.restrict (U i ⊓ U j).ι` object. Since `hf` is in the PROTECTED signature, this requires **mathematician intervention** to re-sign the declaration. Why must-fix: `homOfLocalCompat` is the A-bridge that `exists_tensorObj_inverse` depends on; the sorry is structurally un-fillable as stated, not merely hard.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:581` — `homOfLocalCompat` linearity sorry. Transitively gated on L565. Why must-fix: load-bearing sorry; cannot be addressed until the `hf` signature issue (L565) is resolved.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:43` — Module header says "(iter-252)" for the sorry-count annotation. We are in iter-253. Stale label; minor risk of confusion about which iteration's state is documented.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:43` — Header references `exists_tensorObj_inverse` at "~L699"; actual line is L708. Not misleading but inaccurate.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:32` — Header says `homOfLocalCompat` has one `sorry`; body has two (L565, L581). Under-counting obscures the second blocked step.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1244–1306` — `PullbackLanDecomposition` section: five sorry-free declarations that are explicitly "OFF-PATH" and unused by the active proof strategy. Correct but dead. Should eventually be pruned or moved to a dedicated "reusable supplementary" file to avoid confusion.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:17` — Header says `dual_restrict_iso` PARTIAL at "(iter-251)"; new supporting code (`homLocalSection`, `topSectionToHom`) added this session. The sorry in `dual_restrict_iso` itself is unchanged, but the iter label suggests nothing has changed in the file since iter-251 — misleading.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1657` — `set_option backward.isDefEq.respectTransparency false in` on `epsilonPresheafToSheafUnit`: unusual kernel option with no inline explanation. The proof comment explains the `CommRing`/`ModuleCat` instance resolution issue (`letI` below) but does not explain why this particular option is needed rather than, e.g., a `letI` or `haveI`. Low risk (scoped with `in`) but opaque.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:161–229, 286–331, 451–499` — Very large planner-strategy comment blocks embedded in `/-- ... -/` docstrings (nested `/- Planner strategy: ... -/`). Valid Lean; will appear verbatim in documentation. Consider moving to a separate `.md` planning file or `task_results/` after the proof is complete.

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — Multiple `set_option maxHeartbeats 3200000 in` scopes (L1736, L1967). 16× default is high but each has a detailed explanation. Documenting the minimal sufficient budget (empirically found) would be good hygiene.

---

## Excuse-comments (always called out separately)

None. All `sorry`s in both files are accompanied by honest technical diagnoses of what is needed, with no "will fix later", "placeholder", "temporary wrong def", or equivalent language.

---

## Severity summary

- **must-fix-this-iter**: 6 — all sorry-bearing load-bearing declarations (L708, L1962, L2027 in TensorObjSubstrate.lean; L256, L565, L581 in DualInverse.lean). The L565 sorry is particularly critical: it is structurally un-fillable without mathematician approval to change the protected `hf` signature.
- **major**: 5
- **minor**: 3
- **excuse-comments**: 0

**Overall verdict**: Both files are free of axioms and excuse-comments; the sorry counts match or slightly under-count what the headers advertise; no stale CLOSED claims for actually-closed lemmas. The single serious structural problem is `homOfLocalCompat:L565` — the protected `hf : HEq` signature is incompatible with the proof strategy (HEq over non-propositionally-equal objects), and no prover-side fix is available. This needs mathematician re-signing of the declaration before the A-bridge can close.
