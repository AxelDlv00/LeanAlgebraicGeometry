# Lean Audit Report

## Slug
iter052

## Iteration
052

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **[OK] New decls `gf_patch_free_imp_flat`, `gf_flat_base_local_on_source`, `gf_stalk_flat_localBase`** (lines ~2719–2750): all axiom-clean, no `sorry`. Bodies are one-liners that correctly delegate to Mathlib (`Module.Flat.of_free`, `Module.flat_of_isLocalized_maximal`, `IsLocalization.flat`+`Module.Flat.trans`). None is vacuous or trivially true without content.
  - **[OK] `genericFlatnessAlgebraic`** (lines ~1982–2142): no `sorry`, complex dévissage assembly building on all the `GenericFreeness.*` lemmas. Axiom-clean.
  - **[MAJOR] Stale iter ref in `genericFlatness` sorry body** (line ~2759): the comment inside the sorry body reads `iter-177+: the body follows Nitsure §4:...`. The project is at iter-052. "177+" is either a typo or was copied from a different planning document. At iter-052 this reference is confusing and misleading — a reader cannot tell whether 177 is a future iteration target, a broken numbering, or dead text. Should reference the current iter or omit the iter number entirely.
  - **[MAJOR] Stale GAP G1 claim in `genericFlatness` sorry body** (lines ~2838–2843): the sorry comment states `GAP G1 — quasicoherent + finite-type ⟹ finite section module... NOT yet available`. However `gf_qcoh_fintype_finite_sections` (lines 2663–2682), proved axiom-clean in the SAME file immediately above `genericFlatness`, closes G1 exactly: it provides `IsAffineOpen W → Module.Finite Γ(X,W) Γ(F,W)` under `[F.IsQuasicoherent] [F.IsFiniteType]`. The sorry comment's claim that G1 is a remaining gap is incorrect; it will mislead a future planner into thinking G1 still needs to be built.
  - **[MAJOR] `gf_stalk_flat_localBase` name/docstring mismatch** (lines ~2738–2750): the declaration is named `gf_stalk_flat_localBase` (contains "stalk") but its Lean signature is a purely algebraic localization-transitivity result — it does not reference schemes, structure-sheaf stalks, `SheafOfModules.stalk`, or any geometric object. The docstring header says "G3.4 — stalk flatness over the local base" and the body gives an informal geometric application `R = 𝒪_{S,x}, R' = 𝒪_{S,p(y)}, N = F_y`. The preceding section preamble (lines 2707–2712) explicitly states that the stalk-based blueprint sub-lemma G3.2 is absent from Lean, but the name of G3.4 and the inline application description could mislead a reader into thinking this declaration establishes the geometric "stalk flat over local base" fact. The docstring does say "Stalk-free algebraic core" in the first sentence, which partially mitigates this; nonetheless the name is a persistent red flag. The docstring is *partially* honest but insufficient: it does not say explicitly that the geometric conclusion ("`F_y` flat over `𝒪_{S,x}`") does NOT follow from this Lean declaration alone (the stalk theory bridge is absent).
  - **[MUST-FIX] `genericFlatness` sorry** (line 2856): `:= sorry` (after partial setup) on the central theorem of the file. The sorry is the known open state of the project, not a new issue, and is honestly documented with a detailed roadmap. Per audit protocol a sorry on a load-bearing claim is must-fix regardless.
  - **[MINOR] Historical `SIGNATURE CORRECTNESS FIX (iter-023)`** embedded in `genericFlatness` docstring (lines ~2791–2815): references iter-023 as historical context for the `[QuasiCompact p]` fix. This is acceptable as historical documentation, but the block is long and, combined with the "iter-177+" ref above, produces a confusing multi-generation comment inside a sorry body. Could be trimmed.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 5 flagged
- **notes**:
  - **[OK] `pullbackBaseChangeTransport`** (lines ~196–203): genuine, non-trivial, axiom-clean. The body correctly assembles three `Scheme.Modules.pullbackComp` isomorphisms.
  - **[OK] `glueData_bridge_src`** (line ~209–211): one-liner `pullback.condition`. Genuine (the content is a scheme-category pullback condition), axiom-clean.
  - **[OK] `glueData_bridge_mid`** (lines ~218–223): genuine tactic proof using `t_fac`, `pullback.condition`. Axiom-clean.
  - **[OK] `glueData_bridge_tgt`** (lines ~230–237): non-trivial, uses `t_fac_assoc`, `t_inv`, `cocycle_assoc`. Axiom-clean.
  - **[MUST-FIX + EXCUSE-COMMENT] `glue` sorry** (line 271): `sorry` body on a load-bearing function (`def:scheme_modules_glue`). NOTE comment says "the body and the module-cocycle hypotheses on `g` are still to be filled" — this is "will fill later" language (excuse-comment). The declaration is load-bearing: `universalQuotient`, `tautologicalQuotient`, `functor`, `represents` all depend on it. The sorries are honestly described but are still sorries on substantive claims.
  - **[MUST-FIX + EXCUSE-COMMENT] `universalQuotient` sorry** (line 285): `:= sorry`. NOTE comment: "body to be filled once `glue` lands." Excuse-comment, load-bearing.
  - **[MUST-FIX + EXCUSE-COMMENT] `tautologicalQuotient` sorry** (line 293): `:= sorry`. NOTE comment: "body to be filled once `glue` lands." Excuse-comment, load-bearing.
  - **[MUST-FIX + EXCUSE-COMMENT] `functor` sorry** (line 304): `:= sorry`. NOTE comment: "body (the quotient-of-`Setoid` on rank-`d` quotients + pullback functoriality) to be filled". Excuse-comment, load-bearing.
  - **[MUST-FIX + EXCUSE-COMMENT] `represents` sorry** (line 315): `:= sorry`. NOTE comment: "body (the local-to-global inverse construction of Nitsure §1) to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." Excuse-comment, load-bearing.
  - **[MINOR] `chartQuotientMap`** (line 87–98): marked `noncomputable`; `HasFiniteBiproducts` is inferred via `HasFiniteBiproducts.of_hasFiniteProducts`. This is correct for the sheaf-of-modules category and raises no alarm.
  - **[MINOR] NOTE (scaffold) comment on `glue`** (lines 162–173): the section docstring says "the multiplicative cocycle conditions remain to be added before the construction is closed." This is accurate — the C2 signature is actually in the `glue` type signature as a hypothesis `_hC2`, but the body is sorry. This is honestly described.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **[OK] `isIso_sheafification_map_iff`** (lines ~214–229): genuine, non-trivial, axiom-clean. The proof correctly applies `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` to convert `IsIso (sheafification.map f)` to membership in `(opensTopology X).W`. The `iff` direction flip is clean.
  - **[OK] `localIso_toPresheaf_map_unit`** (lines ~239–243): genuine, one-step proof: rewrites via `toPresheaf_map_sheafificationAdjunction_unit_app` then applies `W_toSheafify`. Axiom-clean.
  - **[OK] `isIso_sheafification_map_unit`** (lines ~251–254): one-liner combining `isIso_sheafification_map_iff` and `localIso_toPresheaf_map_unit`. Axiom-clean. The name clearly describes what is proved.
  - **[OK] Long handoff block comment** (lines ~256–341): this is documentation, not code. It honestly and precisely describes what is deferred (`tensorPowAdd`), why (the strong-monoidality of `sheafification` is needed but missing), what the three blocked routes are (a/b/c), and what the next-iter task is. The handoff clearly states `tensorPowAdd` is "not provided in this iteration" and is "left absent rather than backed by a `sorry`". This is the correct "mathlib-build discipline" approach — NO excuse-comment.
  - **[MINOR] Iter-specific refs in handoff block** (lines ~295–303): text contains `NEW in iter-052` and `ITER-052 STATUS` inline in a code-adjacent comment. These will become stale in iter-053 onwards. Since this is a long-lived handoff comment, these references should either be removed or replaced with date-based anchors. Not critical, but creates comment rot.
  - **[OK] `tensorObj`, `tensorPow`, `moduleTensorPow`** (lines ~82–108): all `noncomputable`, axiom-clean, definitions are exactly the sheafification-of-presheaf-tensor as described.
  - **[OK] `sectionsMul`** (lines ~184–190): axiom-clean, correctly uses the sheafification unit's component.
  - **[OK] `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`** (all `private`, lines ~127–165): axiom-clean. All marked `private`, appropriately — they're internal infrastructure for the eventual `tensorPowAdd`.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:271` — `glue` body is `:= sorry` on a load-bearing function whose body is the module-descent construction. Why must-fix: sorry on a substantive load-bearing claim; 4 downstream declarations all depend on it being real.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:285` — `universalQuotient` is `:= sorry`. Why must-fix: load-bearing sorry (the universal quotient sheaf on Gr(d,r)).
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:293` — `tautologicalQuotient` is `:= sorry`. Why must-fix: load-bearing sorry (the tautological surjection is the moduli data).
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:304` — `functor` is `:= sorry`. Why must-fix: load-bearing sorry (the Grassmannian functor-of-points is needed for the universal property).
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:315` — `represents` is `:= sorry`. Why must-fix: sorry on the universal-property theorem.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:2856` — `genericFlatness` terminates in `sorry`. Why must-fix: sorry on the central theorem of the file. (The prior iter's blueprint GAP G1 is now closed in the same file; see Major findings for the stale-comment corollary.)

---

## Major

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:~2759` — "iter-177+" ref in `genericFlatness` docstring. At iter-052 this is a confusing stale reference with no legible meaning (either a typo or dead planning text).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:~2838–2843` — The sorry body for `genericFlatness` states "GAP G1 — quasicoherent + finite-type ⟹ finite section module... NOT yet available," but `gf_qcoh_fintype_finite_sections` (lines 2663–2682) closes G1 in the same file. This stale gap claim will mislead future planners into thinking G1 must still be built.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:~2738–2750` — `gf_stalk_flat_localBase`: name contains "stalk" but the Lean type is stalk-free. The docstring describes the intended application as `N = F_y, R = 𝒪_{S,x}` without explicitly disclaiming that the bridge from the algebraic fact to the geometric conclusion does not exist in Lean. A reader not already knowing the stalk-theory is absent could infer the geometric application follows from this declaration; it does not.

---

## Minor

- `AlgebraicJacobian/Picard/SectionGradedRing.lean:~295–303` — "NEW in iter-052" / "ITER-052 STATUS" inline in the handoff block. These will become stale by next iter.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:~2791–2815` — Long historical `SIGNATURE CORRECTNESS FIX (iter-023)` comment in the `genericFlatness` docstring. Acceptable as historical documentation but contributes to a confusing multi-generation comment block inside a sorry body; trimming would improve readability.

---

## Excuse-comments (always called out separately)

- `GrassmannianQuot.lean:~173`: "the body and the module-cocycle hypotheses on `g` are still to be filled" (attached to `glue`, which is the gate for 4 further declarations). Severity: critical (load-bearing).
- `GrassmannianQuot.lean:~283`: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." (attached to `universalQuotient`). Severity: critical.
- `GrassmannianQuot.lean:~291`: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." (attached to `tautologicalQuotient`). Severity: critical.
- `GrassmannianQuot.lean:~302`: "NOTE (scaffold): body (the quotient-of-`Setoid` on rank-`d` quotients + pullback functoriality) to be filled" (attached to `functor`). Severity: major.
- `GrassmannianQuot.lean:~313`: "NOTE (scaffold): body (the local-to-global inverse construction of Nitsure §1) to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." (attached to `represents`). Severity: major.

---

## Severity summary

- **must-fix-this-iter**: 6 — these block downstream work in their files until addressed.
- **major**: 3
- **minor**: 2
- **excuse-comments**: 5 (also counted under must-fix-this-iter above; the 5 scaffold comments on the GrassmannianQuot sorries document pending-but-admitted incompleteness).

Overall verdict: The three new axiom-clean declarations in each file (`gf_patch_free_imp_flat`/`gf_flat_base_local_on_source`/`gf_stalk_flat_localBase`; `pullbackBaseChangeTransport`/`glueData_bridge_{src,mid,tgt}`; `isIso_sheafification_map_iff`/`localIso_toPresheaf_map_unit`/`isIso_sheafification_map_unit`) are all genuine and correct; the sorry landscape is as expected (GrassmannianQuot glue gate + 4 scaffolds; genericFlatness) with two actionable stale-comment issues: the "GAP G1" claim in genericFlatness is now incorrect (G1 was closed this iter in the same file), and the "iter-177+" reference is confusing dead text.
