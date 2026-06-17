# Session 237 — review of iter-237

## Metadata
- **Iteration / session:** iter-237 / session_237
- **Model:** claude-opus-4-8
- **Prover lanes:** 2 (both `done`) — `Vestigial.lean` (critical path), `FlatBaseChange.lean` (engine)
- **Per-file sorry deltas:**
  - `Vestigial.lean`: **1 → 0** (the whiskering sorry closed)
  - `TensorObjSubstrate.lean`: 2 → 2 (unchanged: `exists_tensorObj_inverse` L695, `addCommGroup_via_tensorObj` L760)
  - `FlatBaseChange.lean`: 2 → 2 (unchanged: `affineBaseChange_pushforward_iso` L470, `flatBaseChange_pushforward_isIso` L492)
- **Global sorry counter:** `.archon/meta.json` was absent this iter; counts above are first-hand per-file.
- **Build:** GREEN. `lake env lean Vestigial.lean` exit 0, no error/sorry. **Blueprint-doctor:** 1 finding (malformed `\uses{}`, see below). **`sync_leanok`:** iter 237, sha `e451ec60`, +10/−0, chapters `Cohomology_FlatBaseChange.tex` + `Picard_TensorObjSubstrate.tex`.

## Headline — the ~20-iter critical-path bottleneck is GONE

iter-236 built the d.2 ingredient (`stalkTensorIso`). **iter-237 wired it through and closed the consumer.**
`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` — the single sorry that had blocked the associator
since ~iter-217 — is now **axiom-clean**, and the downstream
`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` is **sorry-free + axiom-clean** (I verified directly:
`lean_verify` → `{propext, Classical.choice, Quot.sound}`; it is NOT among the 2 remaining file sorries; and
its `hM/hN/hP` hypotheses are now *unused* — the associator became genuinely flatness-free). The by-hand
`thm:pic_commgroup` is **UNBLOCKED for the first time in ~20 iters.**

The honest caveat: the *canonical critical-path counter did not drop*. The associator is an INGREDIENT; its
consumers `exists_tensorObj_inverse` (L695) and `addCommGroup_via_tensorObj` (L760) in TensorObjSubstrate.lean
are still sorried (the carrier-pivot deferred-bridge lane). Those are the next targets — now reachable with no
known Mathlib gap.

## Target 1 — `isLocallyInjective_whiskerLeft_of_W` (Vestigial.lean) — SOLVED

Six axiom-clean decls added (lines ~389–608), closing the file's last sorry. The proof runs the three
planned movements:
1. **d.1-bridge** `isIso_stalkFunctor_map_of_W`: on the topological site `Opens X`, a `J.W`-morphism of
   presheaves of `Ab` is a stalkwise iso. Built from the NEW presheaf-level
   `injective_stalk_of_isLocallyInjective` (Mathlib has only the *sheaf* version
   `app_injective_iff_stalkFunctor_map_injective`; this was proved directly via `germ_eq` + the
   equalizer-sieve cover) + Mathlib's surjective half + `W_iff_isLocallyBijective` +
   `ConcreteCategory.isIso_iff_bijective`.
2. **B-naturality** of `stalkTensorIso` (under d.2, the stalk of `F ◁ g` is `id_{F_z} ⊗ g_z`) — **inlined**
   as `have key` rather than a standalone decl, to avoid re-plumbing the +/0 carrier duality twice.
3. **Conclusion:** `g_z` iso ⇒ `stalkLinearEquivOfIsIso` ⇒ flatness-free `TensorProduct.congr (refl) g_z`
   iso ⇒ `(F ◁ g)_z` iso ⇒ stalkwise injective ⇒ `isLocallyInjective_of_injective_stalk`.

The whisker lemmas `isLocallyInjective_whiskerLeft_of_W`, `W_whiskerLeft_of_W`, `W_whiskerRight_of_W` were
**specialized** from a general site `C` to `{X : TopCat} {R : X.Presheaf CommRingCat}` (stalks only exist
there) and **relocated** to end-of-file. The consumer (`TensorObjSubstrate.lean:372/375`,
`W_whisker*_of_W (R := X.presheaf)`) infers `X := ↑scheme` and **compiles verbatim** — lean-auditor
confirmed no information the consumer needs was silently dropped (the flat variants remain for general sites).

### Key tactic recipe discovered (the +/0 carrier-duality wall)
The additive instances on defeq carriers `(toPresheaf _).obj (F ⊗ M)` vs `(Monoidal.tensorObj F M).presheaf`
(and `stalkFunctor.obj` vs `stalk … .presheaf`) differ **syntactically**, so `rw [map_add]` / `simp only
[map_add]` will NOT fire on the `AddCommGrpCat` stalk hom `φ` or on `eN`. **Fix:** distribute via
`have h := map_add _ _ _` *terms* (defeq-coerced), then `rw [h]`; for zero use `erw [map_zero …]`;
`simp only [map_add]` DOES fire on the `LinearEquiv` legs whose arguments are already in canonical type.
`LinearEquiv` coe = underlying linear map by **defeq**, so
`have hRM : eM (germ …) = … := stalkTensorLinearMap_germ_tmul …` typechecks with no coe lemma.

## Target 2 — `pushforward_spec_tilde_iso` (FlatBaseChange.lean) — PARTIAL (hard commitment NOT met)

The iter-237 plan made this a **hard sorry-closure commitment** (close `affineBaseChange_pushforward_iso` or
STUCK re-fires). It was **not met**: `affineBaseChange_pushforward_iso` is still sorry.

What WAS built — 3 axiom-clean decls, the entire route-iii skeleton reduced to a single named obligation:
- `IsLocalizedModule.powers_restrictScalars` — the ring-change core (exact converse of Mathlib's
  `IsLocalizedModule.of_restrictScalars`; `Algebra.algebraMapSubmonoid R' (powers a) = powers (φ a)`).
- `fromTildeΓ_app_isIso_of_isLocalizedModule` — the section-level engine: if the structure-sheaf
  restriction `Γ(N,⊤) → Γ(N,D(a))` is `IsLocalizedModule (powers a)`, the counit `fromTildeΓ N` is iso on
  `D(a)`. Both `j` (tilde localization) and `ρ` (restriction) are localizations of `Γ(N,⊤)`, so `L` =
  `(iso j).symm.trans (iso ρ)`, bijective.
- `pushforward_spec_tilde_iso_of_isLocalizedModule` — the full conditional assembly, taking the per-basic-open
  localization fact `hloc` as hypothesis.

**The single remaining obligation `hloc`** = `IsLocalizedModule (powers a)` on the pushforward sections over
`D(a)`. The probe `constructor; intro x; rw [Module.End.isUnit_iff]` reduces it to
`Function.Bijective (a •_R ·)` on `Γ(N,D(a)) = M[1/φa]` — the SAME structure-sheaf smul carrier wall iter-234/236
hit at `⊤` (resolved there only *element-free*). Two routes handed off (element-free `D(a)`-level transport via
`gammaPushforwardIso` + `powers_restrictScalars` — recommended; or direct `IsLocalizedModule.mk` — higher risk).

### Instance-synthesis gotcha (important)
`IsLocalizedModule.linearEquiv S j ρ` and inline `(iso S j).symm.trans (iso S ρ)` **both fail instance
synthesis for `ρ`** even though `inferInstance` succeeds standalone — the `.trans`/`linearEquiv` expected-type
propagation reinterprets `ρ`'s domain so the local instance key no longer matches. **Fix:** elaborate each
`iso` in a separate `set … with` (independent resolution), then `let e := ej.symm.trans eρ`. `j` must be over
the SAME unfolded domain expression as `ρ`, not via a `set ΓN`, or domain types diverge.

## Review-subagent findings (3 dispatched)
All three reports are on disk; details + actions are in `recommendations.md`.
- **lean-auditor ts237** — new decls genuine/non-vacuous, no excuse-comments. 4 must-fix = the *pre-existing*
  load-bearing sorries (not new). 5 MAJOR = stale **.lean docstrings** in TensorObjSubstrate.lean (L43, 305,
  309, 317–340) and Vestigial.lean (L16) that still describe the OLD flatness route / call the whisker lemma
  "one open sorry". (`task_results/lean-auditor-ts237.md`)
- **lean-vs-blueprint-checker vestigial** — 2 must-fix: dangling `\lean{stalkTensorIso_naturality_right}`
  (inlined, no decl) and `\leanok` jammed inside a multi-line `\uses{}` (= the doctor finding); plus several
  major missing pins. (`task_results/lean-vs-blueprint-checker-vestigial.md`)
- **lean-vs-blueprint-checker fbc** — dangling `pushforward_spec_tilde_iso` pin (only conditional built) +
  3 unpinned route-iii helpers. (`task_results/lean-vs-blueprint-checker-fbc.md`)

## Blueprint-doctor
1 finding: `Picard_TensorObjSubstrate.tex` has `\uses{\leanok\n  lem:W_implies_stalkwise_iso}` — `sync_leanok`
inserted `\leanok` between two lines of a multi-line `\uses{}` (the proof block of
`lem:islocallyinjective_whiskerleft_via_stalk`, ~L2227–2229), breaking the `\uses` parse so the edge to
`lem:W_implies_stalkwise_iso` renders missing. **Top recommendation for the plan agent** (I left `\leanok`
untouched per role constraints — the fix is to collapse the `\uses{}` and let `\leanok` sit after the brace).

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation_naturality_right`: added `% NOTE:` — the
  B-naturality was inlined into `isLocallyInjective_whiskerLeft_of_W`; the `\lean{stalkTensorIso_naturality_right}`
  pin is dangling (no such decl).
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_spec_tilde_iso`: added `% NOTE:` — only the conditional
  `pushforward_spec_tilde_iso_of_isLocalizedModule` was formalized; the unconditional pin is dangling; sole
  residual is `hloc`; 2 route-iii helpers also unpinned.
- No `\mathlibok` added (all new decls are genuine constructions, not Mathlib re-exports). No `\leanok`
  touched. No stale `\notready` found in the touched chapters.

## Notes (LOW)
- Informal agent (Kimi) was unavailable this iter: `--provider kimi` → HTTP 401, `--provider kimi-anthropic`
  → HTTP 404. Only `MOONSHOT_*`/`GEMINI_CLI_*` set (not `GEMINI_API_KEY`). The prover proceeded without it.
