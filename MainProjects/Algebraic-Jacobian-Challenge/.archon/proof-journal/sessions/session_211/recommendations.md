# Recommendations for iter-212 (from review of iter-211)

## Headline

iter-211 broke the 5-iter recession pattern: the go/no-go gate
`PresheafOfModules.W_whiskerLeft_of_flat` **CLEARED axiom-clean**, the reversal trigger did
**NOT** fire (no `MonoidalClosed`, no strong-monoidal pushforward), and the ⊗-invertibility
group-law construction is now confirmed buildable. **No USER escalation needed.** The lane is
CONVERGING. Continue it.

## 1. Closest to completion — `tensorObj_assoc_iso` (HIGH priority, single residual pinned)

The associator is a typed sorry whose **single residual is precisely named**: the bridge

```
lemma isIso_sheafification_map_of_W : J.W ((toPresheaf _).map f) → IsIso ((sheafification …).map f)
```

(`J` is the **small-site** topology of `X.ringCatSheaf`, NOT `Scheme.zariskiTopology` — the
zariski probe failed with a type mismatch). Build it from:
- (a) `PresheafOfModules.toPresheaf` **reflecting isomorphisms** (a PoM morphism is iso iff its
  underlying additive presheaf map is sectionwise iso);
- (b) the underlying `AddCommGrpCat`-sheafification being a **localization at `J.W`**
  (`GrothendieckTopology.W_iff_isIso_map_of_adjunction` / `W_iff` /
  `instIsLocalizationFunctorOppositeSheafPresheafToSheafW`), plus a compatibility
  `toPresheaf ∘ sheafification ≅ AddCommGrp-sheafify ∘ toPresheaf`;
- (c) the `IsInvertible ⇒ sectionwise Module.Flat` derivation (invertible ⇒ locally free rank 1
  ⇒ sections flat) that feeds `W_whiskerLeft_of_flat`'s `[∀ X, Module.Flat …]` instance.

Plus the cheap `W_whiskerRight_of_flat` (conjugate `W_whiskerLeft_of_flat` by the braiding).
**Est. ~80–150 LOC of sheafification-localization plumbing.** This is a focused `prove` (or
`scaffold+prove`) lane, NOT a blocked node. HARD GATE: the chapter cleared `complete+correct`
this iter, so a prover may be dispatched directly (re-confirm via the mandatory blueprint-reviewer
pass next iter, but no writer fix is owed).

## 2. After the associator — the group-law engine (MEDIUM)

- `tensorObjIsoclassCommMonoid` (`lem:tensorobj_isoclass_commgroup`): the prover deliberately did
  NOT scaffold this as a hollow sorry — its carrier type (`Units (Skeleton …)`-shaped iso-classes
  of `IsInvertible` objects) is an undetermined design decision and it *consumes* the associator.
  **Plan agent: pin a precise carrier type mirroring `CommRing.Pic = Units (Skeleton (ModuleCat R))`
  once the associator's bridge lands.** Do not dispatch before the carrier is pinned.
- `addCommGroup_via_tensorObj` (downstream RPF-L235 consumer): closes only after the associator +
  commMonoid land. Leave parked until then.

## 2b. Lean hygiene — deprecation sweep (MAJOR, from lean-auditor ts211)

Both review subagents came back with **0 must-fix**. The lean-auditor's one actionable cluster
(`task_results/lean-auditor-ts211.md`, severity MAJOR):

- **Deprecated `CategoryTheory.Sheaf.val` — 10 uses** across all 7 new non-sorry `Scheme.Modules`
  definitions (`TensorObjSubstrate.lean:366,383,428,445,447,457,459,467,469,477`). Replacement
  accessor is `ObjectProperty.obj`. Currently only compiler warnings, but **the file will break at
  the next Mathlib-pin bump that removes the alias.** Schedule a mechanical `.lean` sweep (prover or
  refactor) — best folded into whichever prover next touches the file (e.g. the associator lane).
- Minor brittleness markers (do not block): `set_option backward.isDefEq.respectTransparency false`
  on the three `restrictScalars*` decls (signals `restrictScalars` args don't unify at `.instances`
  transparency); 9 unexplained `erw` beyond the sanctioned line 305 (the recurring
  `presheaf_map_apply_coe` + `tensorObj_map_tmul` pair suggests a shareable helper lemma); an unused
  `ext r` at line 120 (drop the pattern). All in `task_results/lean-auditor-ts211.md`.

## 3. Blueprint / Lean hygiene (LOW, fold into the iter-212 writer/prover directive)

- **`IsInvertible` vs `IsLocallyTrivial` carrier bridge** (blueprint-reviewer `soon` #2): `IsInvertible`
  now EXISTS in Lean (created this iter). But the blueprint's `LineBundle.OnProduct := {M | IsInvertible M}`
  vs the Lean file's `IsLocallyTrivial`-based implementation still needs a one-sentence writer note
  blueprinting the bridge `LineBundle.IsLocallyTrivial → Scheme.Modules.IsInvertible`. A prover
  connecting `tensorObjOnProduct` to the group-law engine will need this. Dispatch a scoped writer
  on `Picard_TensorObjSubstrate.tex` to add it.
- **`\leanok` sync watch** (lean-vs-blueprint-checker ts211 informational): `lem:tensorobj_unit_iso`
  carries a two-name pin `\lean{…tensorObj_left_unitor, …tensorObj_right_unitor}` and did NOT
  receive a `\leanok` from `sync_leanok` this iter despite both decls being proven sorry-free — the
  comma-separated pin may trip the deterministic decl lookup. The `lem:flat_whisker_localizer` pin
  was mis-namespaced and is corrected this iter (will `\leanok` next sync). If `unit_iso` still lacks
  `\leanok` after the iter-212 sync, the two-name pin format needs investigation (sync's domain, not
  a manual fix).
- **Thin general-M unitor sketch** (blueprint-reviewer informational): `lem:tensorobj_unit_iso`'s
  sketch covers the self-tensor case better than the general `𝒪_X ⊗ M → M` case; one sentence on
  the counit iso on `𝟙` (relating `O_X.val` to the presheaf unit) would help. The unitors are
  already PROVEN in Lean, so this is doc-only — low priority.
- **Stale Lean module-level docstring** (blueprint-reviewer informational): the docstring still says
  "iter-202 Lane TS file-skeleton" and lists `monoidalCategory` as one of 4 pinned decls
  (removed at the iter-206 pivot). This is a `.lean`-file doc fix the *prover* who next touches the
  file should make (review/plan cannot edit `.lean`). One-line fix.

## 4. Do NOT re-dispatch (off the critical path)

- **`tensorObj_restrict_iso`**: removed from the group-law critical path by the iter-209 pivot. The
  associator uses flat-whiskering, not this restriction-compatibility iso. Its residual is
  ~200–300 LOC across 4 absent Mathlib ingredients (opaque `PresheafOfModules.pullback`; see
  `informal/tensorObj_restrict_iso.md`). Leave it parked — do not retry.
- **`exists_tensorObj_inverse`**: also off-path under `IsInvertible` (the inverse is carried by the
  predicate existentially). Leave parked.

## Reusable proof patterns discovered

- **Forcing a monoidal/braided instance through a non-syntactic type**: when `M.val :
  PresheafOfModules X.ringCatSheaf` is defeq-but-not-syntactically `PresheafOfModules (R ⋙ forget₂ …)`,
  the `λ_`/`ρ_`/`β_` notation FAILS (type ascription is transparent, does not redirect instance
  resolution). **Force the instance explicitly**:
  `(PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val`,
  `BraidedCategory.braiding (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ …)) M.val N.val`.
- **`tmul_zero` under `restrictScalars`**: when a tensor factor is a `restrictScalars`-image module,
  `TensorProduct.tmul_zero`'s `Module` instance fails to synthesize on the displayed type; `rw`/`exact`/
  `simp`/`module`/`abel` all fail. Use `erw [TensorProduct.tmul_zero]; rfl`.
- **Localizer universe binder**: the sheafification localizer over presheaves of modules is over
  `Ab.{u}` (target of `PresheafOfModules.toPresheaf`); the instance binder must be
  `[J.WEqualsLocallyBijective Ab.{u}]` with the **explicit** universe or synthesis fails (`Ab`
  defaults to a different universe).

## Reversal pre-commitment status

The iter-211 reversal trigger (gate bottoming out in `MonoidalClosed`) **did not fire** — it is now
spent. There is no armed escalation entering iter-212. The next genuine reversal would be the
associator residual (`isIso_sheafification_map_of_W`) itself bottoming out in absent multi-file
infra; the prover's diagnosis (toPresheaf reflects isos + AddCommGrp-sheafification is a localization)
judges it present, but iter-212 should watch for it.
