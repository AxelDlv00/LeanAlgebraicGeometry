# Session 14 — Review of iter-014

## Metadata

- **Iteration / session:** iter-014 / session_14
- **Build:** GREEN (both prover-touched files compile clean; blueprint-doctor: no structural findings)
- **Sorry counts (per file, before → after):**
  - `FlatBaseChange.lean`: 5 → **4** (−1, Seam 1 closed)
  - `FlatteningStratification.lean`: 5 → **4** (−1, `gf_torsion_reindex` closed; +5 axiom-clean helpers)
  - `QuotScheme.lean`: 4 → 4 (no prover lane this iter; QUOT mathlib-build committed iter-015)
  - `GrassmannianCells.lean`: 0 → 0 (DONE)
  - `RegroupHelper.lean`: 0 → 0 (DONE)
- **Targets attempted:** 2 hard-must-close lanes (both CHURNING correctives from progress-critic). **Both SOLVED, both axiom-clean** (`{propext, Classical.choice, Quot.sound}`, independently re-verified by `lean_verify` on the current tree).

## Headline

Both CHURNING-must-close walls broke this iter — the two correctives the planner staged (FBC: the
mathlib-analogist's `unit_conjugateEquiv_symm` conjugate-calculus idiom; GF: top-level helper
factoring of the (a)–(e) transport) each worked end-to-end. No fake statements, no weakened defs,
no `axiom`s. Five new general-purpose GF helpers landed axiom-clean.

---

## Target 1 — `base_change_mate_unit_value` (FBC Seam 1) — **SOLVED, axiom-clean**

The CHURNING (2 prover-iters old) `conjugateEquiv` wall closed via the analogist's 4-move recipe
(`analogies/fbc-mate.md`), executed in full. The genuinely new content reduced to a single
**right-triangle identity of the tilde ⊣ Γ adjunction** plus β-naturality and the conjugate-unit
coherence.

### Proof structure (final)
- **Move 1** (`hunitL`): `Adjunction.comp_unit_app` + `tilde.adjunction.unit = toTildeΓNatIso.hom`
  splits the first two factors into `adjL.unit.app M`. Closes by `rw [..., Adjunction.comp_unit_app]; rfl`.
- **Move 3** (`hunitR`): same lemma on `adjR.unit` splits off the algebraic unit `η_M`.
- **Move 2** (`hpullinv` + `huce`): `((conjugateEquiv adjL adjR).symm β.hom).app M = pullback_spec_tilde_iso.inv`
  by `rfl` (it is the *definition* of `pullback_spec_tilde_iso` via `conjugateIsoEquiv`);
  `CategoryTheory.unit_conjugateEquiv_symm adjL adjR β.hom M` gives the central identity.
- **Move 4 / Claim A** (`hClaimA`): the pushforward dictionary, read on Γ and post-composed with the
  tilde–Γ unit, equals `gammaPushforwardTildeIso`. Reduces to
  `tilde.adjunction.right_triangle_components` (`fromTildeΓ` is the tilde ⊣ Γ counit).
- **Assembly**: `← Functor.comp_map` puts the goal in composed-functor form so
  `erw [β.hom.naturality_assoc]` + `erw [reassoc_of% huce]` fire, then
  `rw [hunitR]; simp [← Functor.map_comp]; rw [← Iso.app_hom, ← Iso.app_inv, Iso.hom_inv_id, Functor.map_id, Category.comp_id]`.

### Key learnings / dead-ends
- **`rw`/`simp only` repeatedly fail on functor-composition object forms** (`G.obj (F.obj X)` vs
  `(F⋙G).obj X` — defeq but not syntactic). Errors: *"Tactic `rewrite` failed: Did not find an
  occurrence of the pattern …"* (lines 47–57 of attempts). Multiple `conv_lhs` / explicit
  `← Category.assoc _ _ _` variants all failed the same way. **Fix that worked:** normalise with
  `simp only [← Functor.comp_map]` / `Functor.comp_map` and use `erw` (defeq matching).
- `set_option maxHeartbeats 4000000 in` must precede the **docstring**, not sit between docstring
  and decl (*"unexpected token 'set_option'; expected 'lemma'"*). The chained `erw` defeq
  unifications + the closing `simp` exceed the default budget; budget bump carries an honest
  explanatory comment.
- `NatIso.naturality_1` (NOT `_2`) matches `(tilde⋙Γ).map f = α.inv ≫ f ≫ α.hom`.
- `Iso.hom_inv_id_app` does **not** fire on `nat.hom.app X ≫ nat.inv.app X`; convert via
  `← Iso.app_hom, ← Iso.app_inv` first, then `Iso.hom_inv_id`.
- The opaque-`conjugateIsoEquiv` element-chase warned against in the analogy was indeed a dead end;
  the abstract calculus closed it. No new top-level declarations were introduced (all `have`s local).

---

## Target 2 — `gf_torsion_reindex` (GF L5b) — **SOLVED, axiom-clean**

The CHURNING (sorry 5→5→5, 3 consecutive PARTIAL) reindex closed by factoring the (a)–(e) transport
into standalone helpers — the corrective the prover itself had recommended. The hard finiteness
content `Module.Finite (Pg⧸⟨Fg⟩) Tg'` (landed iter-012) was kept verbatim.

### Proof structure (final)
- **(a)/(b)** `ebar : Pg ≃+* Pg` via **`IsLocalization.ringEquivOfRingEquiv`** (NOT `algEquivOfAlgEquiv`
  — the latter needs `Algebra A (doubly-indexed ring)` which does not synthesize). `ebar Fg = G` via
  `ringEquivOfRingEquiv_apply` + `IsLocalization.map_eq`; `ψ : Pg/(Fg) ≃ Pg/(G)` via
  `Ideal.quotientEquiv` with `hspan` from `Ideal.map_span`.
- **(c)/(d)** helper **`finite_of_quotientRingEquiv`** (`AlgEquiv.ofRingEquiv` + `Module.Finite.equiv`
  + `Module.Finite.trans`).
- **(e)** helper **`isLocalizedModule_restrictScalars`** (the descent instance the iter-012 prover
  flagged missing) → `IsLocalizedModule.linearEquiv` produces `T_g ≃ₗ[A] LocalizedModule MC T`.
- **The non-obvious wall:** the goal's `IsScalarTower A_g R T_g` existential resolves `SMul A_g T_g`
  to the **canonical `OreLocalization.instSMul`** (global instance beats the anonymous existential
  binder), so the tower must hold for canonical-`A_g` + the transported `R`-action — forcing a proof
  that `eAdd` is `A_g`-linear. Resolved via `LinearEquiv.extendScalarsOfIsLocalization` (eAgL) +
  helpers `pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower`.

### Key learnings / dead-ends
- `IsScalarTower.of_algebraMap_smul fun _ _ => rfl` fails (*"Type mismatch: rfl … (algebraMap A P) x • x = x • x"*)
  — the `compHom` A-action doesn't reduce by `rfl`; use `inferInstance`.
- `localizedModuleIsLocalizedModule MC T` is *"Function expected … but this term has type IsLocalizedModule …"* —
  call as `localizedModuleIsLocalizedModule (M := T) MC`.
- The `hCeq` step + transport timed out at `whnf` (1000000 heartbeats) before the bump to 4000000;
  **factoring (not the budget) is what avoided the blow-up** — the budget only covers the residual
  `A_g`-linearity transport. Bump carries an honest comment.
- `show` → `change` for defeq goals the elaborator rejects under `show`.

---

## Cross-cutting findings / reusable patterns

- **`erw` + `← Functor.comp_map` for functor-composition defeq.** When a category-theory rewrite is
  the correct lemma but `rw`/`simp only` report "pattern not found" because the codomain is written
  `G.obj (F.obj X)` while the lemma's domain is `(F⋙G).obj X`, normalise with `Functor.comp_map`
  and switch to `erw`. (FBC Seam 1.)
- **`IsLocalization.ringEquivOfRingEquiv` over `algEquivOfAlgEquiv` on doubly-indexed rings.** The
  alg-equiv version needs an `Algebra` instance that won't synthesize on `MvPolynomial (Fin n) A_g`;
  the ring-equiv version only needs `Algebra P Pg` + `IsLocalization`, both present. (GF reindex.)
- **The canonical `OreLocalization` action diamond beats the existential binder.** An `∃ … [Module A_g M] …`
  goal resolves `SMul A_g (LocalizedModule S M)` to the canonical instance, ignoring the provided
  witness — so any transported action must be proved to agree with the canonical one on constants.
  (GF reindex.)
- Both confirm the prior **inline-instance-stacking → factor into helpers** pattern (iter-012): the
  corrective for `isDefEq`/`whnf` blow-ups is decomposition, not a bigger heartbeat budget.

## Subagent reports (all returned; 0 must-fix collectively)

- `lean-auditor iter014` — 7 files, **0 must-fix**, 4 major (1 new + 3 known), 4 minor (1 new + 3 known),
  0 excuse-comments. New major = stale comment `FlatteningStratification.lean:1322–1323`
  ("once `gf_torsion_reindex` (L5b, still `sorry`) lands" — it lands now). `maxHeartbeats` bumps carry
  honest comments; no scratch/`#check`/`ScratchCheck` left behind. Report: `task_results/lean-auditor-iter014.md`.
- `lean-vs-blueprint-checker fbc` — 34 decls, **0 must-fix / 0 major**, 1 minor (Seam-1 sketch could
  name its 3 intermediate coherence steps). Seam 1 content matches the chapter. Coverage 34/34.
  Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- `lean-vs-blueprint-checker gf` — 29 blueprint decls, **0 must-fix**, 1 major (chapter "Transitivity"
  step of `lem:gf_torsion_reindex` under-specified vs the ~200-line Lean — the 5 new helpers are the
  evidence), 2 minor (stale comment line 1323; 5 unmatched helpers). Reindex content matches the L5b
  decomposition. Report: `task_results/lean-vs-blueprint-checker-gf.md`.

## Notes (LOW)

- lvb-gf observed `exists_localizationAway_finite_mvPolynomial` carries `sorryAx` (transitively, via
  its still-open downstream `sorry`s) — expected, not a regression.
- 22 `CategoryTheory.Sheaf.val` deprecation warnings persist in FlatBaseChange.lean (cosmetic; clear
  in a future refactor pass).

## Recommendations

See `recommendations.md`. Headline: (1) FBC Seam 2 (`base_change_mate_fstar_reindex`) is the next
FBC critical path and now unblocked by Seam 1 — mirror `base_change_mate_codomain_read`'s
leg-identification scaffold. (2) GF L5 `exists_free_localizationAway_polynomial` is unblocked by the
reindex — dispatchable, but a blueprint-writer must first add the 5 helper blocks + expand the
"Transitivity" step (lvb-gf major). (3) QUOT mathlib-build is the committed iter-015 lane.

## Blueprint markers updated (manual)

- None. No `\mathlibok` candidates (the 5 new GF helpers are project decls, not Mathlib re-exports;
  the closed targets keep their names, so no `\lean{...}` corrections), no stale `\notready` to strip.
  `\leanok` on the two closed proof blocks is owned by the deterministic `sync_leanok` (ran for
  iter-014, sha c1a493e, +50/−18).
