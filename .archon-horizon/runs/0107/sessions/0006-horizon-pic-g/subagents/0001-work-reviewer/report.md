Issue filed as I-1709. My review is complete.

## Verdict: CONVERGING — real, usable contribution. One cosmetic overclaim.

The two commits by lane pic-g land a genuinely new, sorry-free, axiom-clean term that fills a hypothesis a dozen downstream lemmas assumed and that the inbox (I-1603, I-1704) and `P1H1Vanishing.lean:69` recorded as "constructed nowhere." This is not helper-churn or blueprint-only motion — it produces the missing section term at the object the headline is about.

### CONFIRMED
- **Build**: `lake build AlgebraicJacobian.Curve.P1Section` → EXIT=0 (the initial `lake env lean` also passed; a first probe *falsely* reported `unitPoint` unknown due to a stale olean from before the second commit — rebuilding fixed it).
- **Axiom-clean**: `overSection`, `unitPoint`, `specPoint_naturality` each depend only on `[propext, Classical.choice, Quot.sound]`. No `sorryAx`.
- **Types are honest, not vacuous**:
  - `overSection k A : overSpec k A ⟶ (P1.asOver k)` type-checks, and `(overSection k A).w` confirms `.left ≫ (P1.asOver k).hom = (overSpec k A).hom` — a real section over `Spec k`, not a formal wrapper.
  - `unitPoint k : 𝟙_ (Over (Spec (.of k))) ⟶ (P1.asOver k)` type-checks. The source really is the monoidal unit; the `w`-condition is discharged by an explicit proof (`Spec.map_id` + `algebraMap k k = 𝟙`), not by an assumed defeq. The type is not a lie.
  - `specPoint_naturality` is substantive: it rewrites through `SpecMap_fromSpecChart` and proves the chart-coordinate `0 ↦ 0` and base-map factoring — not trivially true, not a degenerate/mismatched map.
- **Downstream usable**: `σ`-slot of `PicEtAff.unitEquiv_of_section` / `relPicToPicEt_surjective_of_section` is `overSpec k K ⟶ C` with `K` a *field*; `overSection k K` (built for arbitrary `CommRing`) fits at any field test since `Field → CommRing`. The `P`-slot of `Challenge.exists_unique_ofCurve_comp` is `𝟙_ (Over (Spec (.of k))) ⟶ C`; `unitPoint k` matches exactly with `C := P1.asOver k`. Types line up.
- **No hidden hypothesis in the building block**: `fromSpecChart = Spec.map (chartEval …) ≫ chartι` carries no positivity / separable-closure / nonemptiness assumption, consistent with the docstring's claim.

### Defect (cosmetic, non-load-bearing) — filed as I-1709
The commit-`dfffd6a245` message ("defeq overSpec k k") and the `P1Section.lean:80` docstring ("definitionally `Over.mk (𝟙 (Spec k)) = overSpec k k`") overstate. Verified by `rfl`: `𝟙_ = Over.mk (𝟙 (Spec k))` **is** defeq, but `Over.mk (𝟙 (Spec k)) = overSpec k k` is **not** — `overSpec k k` reduces to `Over.mk (Spec.map (algebraMap k k))`, and that equals `Over.mk (𝟙 (Spec k))` only propositionally (via `Spec.map_id` and `algebraMap k k = id`). The `unitPoint` proof itself already performs those rewrites, so nothing is broken — only the motivating prose calls "propositional" equality "definitional." Suggested reword is in the issue.

No vacuity, no type mismatch, no axiom leak, no build failure. The write set matches the task (single new file + one root import). Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/P1Section.lean`.
