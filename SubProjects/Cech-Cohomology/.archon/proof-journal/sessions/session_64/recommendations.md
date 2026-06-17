# Recommendations — next plan iter (after iter-064)

## Context in one line
iter-064 executed the prescribed **mode-switch to fine-grained decomposition**. It worked: the two
terminal-wall monoliths (CSI Stub-2 chain, OpenImm `case hqc`) are gone, replaced by small precise
leaves. Project real sorry **9 → 12 BY DESIGN**. 3 genuine results closed. Both routes are now in
the **"small leaf + finish the blueprint detail" regime**, NOT churning. The next round is targeted
prover work — but the HARD GATE requires a blueprint-writer pass first on the named items below.

---

## TOP PRIORITY — HARD GATE items (blueprint-writer BEFORE any prover round)

### lvb-csi 2 must-fix (CSI chapter, `Cohomology_CechHigherDirectImage.tex`)
Both block re-dispatching a prover on the 2 CSI induction leaves. Dispatch a **blueprint-writer**
on the consolidated chapter to:
1. **Add a dedicated lemma block for the reindex step** `coprodToProd_isIso_of_equiv` (CSI line 988).
   The current sketch is one thin sentence; it needs the full `whiskerEquiv` transport equation
   (`coprodToProdMap F legs = (pushPullObjCongr F oe).hom ≫ coprodToProdMap F (legs∘e) ≫
   (Pi.whiskerEquiv e _).hom`), the source-iso `Over.isoMk` descent-agreement, and the
   `Sigma.whiskerEquiv`/`Pi.whiskerEquiv`/`overSigmaDescIso` ingredients.
2. **Add the IsZero-over-empty-scheme detail to `lem:pushPull_coprod_prod_empty`** (CSI line 968) —
   the blueprint currently claims "both sides terminal" as if trivial, but the real residual is
   `IsZero ((pullback q).obj F)` over `∐ PEmpty`, needing presheaf-of-modules IsZero-from-pointwise
   (`isZero_iff_id_eq_zero` + faithful `toPresheaf` + pointwise `instSubsingleton…OfIsEmpty`).
Then take the same-iter fast-path (scoped blueprint-reviewer on the chapter) to clear the gate.

### lvb-openimm 1 minor (same chapter) — detail φ'' codomain bridge (b)
`lem:slice_reverse_ring_map`'s proof under-specifies the keystone object-relabel iso (part b). Have
the blueprint-writer spell out:
`X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (pushforward (Over.map (unitIso.inv.app Uᵢ))).obj (X.ringCatSheaf.over Uᵢ)`
(structure ring sheaf along an opens-iso `Over.map` = restriction over the smaller open). This is
the single keystone the OpenImm prover targets next — detailing it is cheap leverage.

### lean-auditor 1 major — Lean comment fix (prover-side, not a gate)
`OpenImmersionPushforward.lean:861-862`: the inline comment says `case hqc` is "discharged **in full**
by `pushforward_iso_preserves_qcoh`" — but that lemma transitively depends on 4 open leaves
(`#print axioms` of `_acyclic` still reports `sorryAx`). Direct the OpenImm prover to reword to
"discharged **modulo the 4 leaf sorries** (φ'', H₁, H₂, section identity)". Low-risk, do it on the
next OpenImm touch.

---

## Closest-to-completion targets to prioritize

### OpenImm — ONE keystone dispatch closes the whole `_acyclic` cone
After the φ''-bridge blueprint detail lands, dispatch a prover on **`sliceReverseRingMap` (φ'') ALONE**
(`OpenImmersionPushforward.lean:588`). The chain above it is already wired sorry-free:
- `pushforwardSliceTwoAdjunction`, `pushforward_iso_preserves_qcoh` — bodies sorry-free (modulo leaves).
- `case hqc` already `exact`s `pushforward_iso_preserves_qcoh`.
- Once φ'' is concrete: `pushforwardSliceAdjunctionH1/H2` (lines 644/654) → eqToHom squares;
  `pushforwardSlicePullbackIso` Step-2 (line 687) → rfl-clean section identity.
So φ'' is the single gate; closing it cascades to close `_acyclic`, then assemble `_comp` (line 910).
**Do NOT dispatch the whole chain** — target φ'' only. φ'' residual = bridge part (a)
`sheafPushforwardContinuousComp'` (mechanical) + part (b) the object-relabel iso (~40–80 LOC, the
genuine wall).

### CSI — 2 small induction leaves close Stub 2
After the blueprint-writer pass, a `prove`/fine-grained pass on:
- `coprodToProd_isIso_of_equiv` (line 988) — Pi.hom_ext + `erw` projection chase + forward
  `pushPullMap_comp` fold (EXACTLY the now-documented Option-step technique). ~80 LOC, all
  ingredients exist.
- `pushPull_coprod_prod_empty` (line 968) — build `IsZero ((pullback q).obj F)` over the empty scheme.
Closing both closes `pushPull_coprod_prod` → `pushPull_sigma_iso` (Stub 2) → `pushPull_eval_prod_iso`
(Stub 4, already assembled). Then the live CSI frontier moves downstream to **Stubs 5/6**
(`cechSection_complex_iso` line 1343, `cechSection_contractible` line 1410) — the augmented-section
-complex iso + contracting homotopy (degree-0 augmentation equalizer is the documented sub-blocker).

---

## Reusable proof patterns discovered (see PROJECT_STATUS Knowledge Base, iter-064 entry)
- **erw-vs-rw for push–pull projections** — `prod.lift_fst`/`prod.lift_snd_assoc`/`Pi.lift_π` over
  push–pull product objects fire ONLY under `erw`, never `rw`/`simp only`.
- **beta-redex product mismatch → `let`-bind to an fvar** (`let ls := fun a => legs (some a)`).
- **reverse `← pushPullMap_comp` whnf-timeout → forward-fold via a `heq` over-morphism identity.**
- **`IsContinuous` on `.symm.functor`/`.symm.inverse` is defeq-not-syntactic** → explicit `haveI`.
- **universe pinning** `SheafOfModules.pullback.{u}` / `pullbackPushforwardAdjunction.{u}`.

---

## Coverage debt — 11 unmatched `lean_aux` nodes (blueprint these)
10 are new iter-064 CSI helpers (the 11th is the dead `CechAcyclic.affine`). The planner should add
blueprint entries (or bundle into a parent `\lean{}` list) for:
- `coprodOverIncl` — over-inclusion of leg `i` into the descent object `Over.mk (Sigma.desc (·.hom))`.
- `coprodToProdMap` — `Pi.lift` of per-leg push–pull maps (the comparison map).
- `coprodToProdMap_comp_π` — `coprodToProdMap F legs ≫ Pi.π _ i = pushPullMap F (coprodOverIncl …)`.
- `coprodToProd_isIso_option` — Option-adjoining induction step (CLOSED this iter).
- `coprodToProd_isIso_of_equiv` — reindex induction step (open; gets its own lemma block per lvb-csi).
- `isIso_coprodToProdMap` — the `Finite.induction_empty_option` driver.
- `piOptionIso_inv_π_none` / `piOptionIso_inv_π_some` — projections of `(piOptionIso W).inv`.
- `pushPullObjCongr_hom` — `(pushPullObjCongr F e).hom = pushPullMap F e.inv` (rfl).
- `pushPull_binary_coprod_prod_hom` — binary iso `.hom` as the canonical `prod.lift` (rfl).
(`coprodToProd_isIso_of_equiv` and `pushPull_coprod_prod_empty` are already named in the chapter via
the `lem:pushPull_coprod_prod` \uses block; the planner should confirm each helper resolves once
blueprinted.)

## Do-NOT-retry / hygiene
- Do NOT treat `higherDirectImage_openImmersion_acyclic` as done because its body is sorry-free — it
  transitively depends on 4 leaves (`sorryAx`). It closes only when φ'' lands.
- Latent (still live from iter-063): `isZero_of_faithful_preservesZeroMorphisms` is DUPLICATED under
  the same fully-qualified name in `OpenImmersionPushforward.lean` AND `CechAugmentedResolution.lean`
  — a joint-import redeclaration error waiting to fire at P5b assembly; hoist to a shared module.
- Minor hygiene (lean-auditor): add an explanatory comment to `set_option synthInstance.maxHeartbeats
  800000` at CSI:1165 (`pushPull_sigma_iso`); the stale "residual = three induction steps" comment at
  CSI:698 should read "two" (Option step is closed).
