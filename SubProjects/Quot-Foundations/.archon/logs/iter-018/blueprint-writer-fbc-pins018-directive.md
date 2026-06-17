# Blueprint Writer Directive

## Slug
fbc-pins018

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Strategy context
The FBC-A route proves the affine base-change lemma directly on global sections (Stacks 02KH part 2). The Seam-2 identity `lem:base_change_mate_fstar_reindex` was structurally refactored in the last prover pass: the "motive is not type correct" wall was dissolved by lifting the two pullback cone-legs to free variables so `subst` acts on a well-typed motive. This produced FIVE new Lean helper declarations that currently have NO blueprint entry (coverage debt — isolated `lean_aux` nodes invisible to the dependency graph). Your job is to give each a proper blueprint block so the 1-to-1 Lean↔blueprint correspondence is restored and the Seam-2 `\uses{}` graph is accurate. These are project-bespoke tactic-decomposition helpers (NO external source — they stand on their one-line informal statements alone; omit `% SOURCE` lines).

## Required content

Add five new blocks, placed near the existing `lem:base_change_mate_codomain_read` (line ~1125) and `lem:base_change_mate_fstar_reindex` (line ~1490) blocks. All are project-bespoke (no `% SOURCE`). Each needs `\label{}`, `\lean{}` (exact Lean name), accurate `\uses{}`, a concise informal statement, and a one-line informal proof.

1. **Lemma `lem:gammaMap_pushforwardComp_hom_eq_id`** — `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}`.
   Statement: For composable `a, b` and a module `M`, applying the global-sections functor `moduleSpecΓFunctor` (over base `R`) to the component `(pushforwardComp a b).hom.app M` of the pushforward-composition isomorphism yields the identity morphism. (The pushforward-composition coherence is transparent at the level of sections.)
   Proof: `(pushforwardComp a b).hom.app M` is the identity by definitional transparency, and `moduleSpecΓFunctor` sends the identity to the identity.
   `\uses{}`: this depends on the pushforward-composition isomorphism and `moduleSpecΓFunctor`; reference whatever existing block names them (e.g. the pushforward functor / `gammaPushforward*` blocks). Keep the `\uses{}` minimal and accurate — verify via `leandag`.

2. **Lemma `lem:gammaMap_pushforwardComp_inv_eq_id`** — `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}`.
   Statement: the same Γ-collapse for the inverse component `(pushforwardComp a b).inv.app M` = identity.
   Proof: same recipe as above (inverse component is also transparently the identity at section level).

3. **Lemma `lem:gammaMap_pushforwardCongr_hom`** — `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}`.
   Statement: For `f = g : X ⟶ Spec R`, applying `moduleSpecΓFunctor` to `(pushforwardCongr hfg).hom.app M` yields the canonical `eqToHom` transport induced by the equality `f = g`.
   Proof: substitute the equality; the congruence isomorphism becomes the identity, whose Γ-image is `eqToHom rfl`.

4. **Lemma `lem:base_change_mate_codomain_read_legs`** — `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}`.
   Statement: the abstract variable-legs form of `lem:base_change_mate_codomain_read`. Given `ψ : R ⟶ R'`, `φ : R ⟶ A`, a module `M`, AND arbitrary morphisms `g' f'` together with hypotheses identifying them with the pullback cone-legs (`hfst : pullback.fst = g'`, `hsnd : pullback.snd = f'`), there is an isomorphism `Γ((pushforward f').obj ((pullback g').obj (tilde M))) ≅ restrictScalars ιR' (extendScalars ιA M)`. This is the codomain read with the legs lifted to free variables (the structural device enabling `subst`).
   Proof: identical construction to `lem:base_change_mate_codomain_read` but with the legs as free variables carrying the identification hypotheses; `subst` then acts on a well-typed motive.
   `\uses{lem:base_change_mate_codomain_read}` (and whatever that block uses — `lem:pullback_fst_snd_specMap_tensor`, the pushforward/pullback dictionaries). Verify with `leandag`.

5. **Lemma `lem:base_change_mate_fstar_reindex_legs`** — `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}`.
   Statement: the abstract variable-legs form of the whole Seam-2 reindex identity, parametrised over generic legs `g' f'` with the cone-leg identification + commutativity hypotheses, with the codomain read supplied by `lem:base_change_mate_codomain_read_legs`. Instantiating at the literal pullback legs recovers the concrete `lem:base_change_mate_fstar_reindex`.
   Proof sketch: `subst` the leg hypotheses (now well-typed), apply the step-(ii) Γ-collapses (`lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom`), then the step-(iii) reduction to Seam-1 via `lem:pullbackPushforward_unit_comp` + `lem:base_change_mate_unit_value` (the mate-unwinding crux — currently the open obligation). This block carries the live Seam-2 proof content.
   `\uses{lem:base_change_mate_codomain_read_legs, lem:gammaMap_pushforwardComp_inv_eq_id, lem:gammaMap_pushforwardCongr_hom, lem:pullbackPushforward_unit_comp, lem:base_change_mate_unit_value, lem:base_change_mate_inner_value}`.

After adding these, update `lem:base_change_mate_fstar_reindex`'s `\uses{}` so the concrete lemma references `lem:base_change_mate_fstar_reindex_legs` (it now reduces to it by `exact`). Verify the whole Seam-2 `\uses{}` neighbourhood with `leandag` — target: no isolated nodes, no `unknown_uses`.

## Minor prose fixes (optional, if quick)
- In `lem:base_change_mate_fstar_reindex` step-(ii) prose, you MAY add one clause noting that the `pushforwardComp.hom` Γ-collapse fires during step (iii) rather than at the step-(ii) point (a transparent re-association detail) — this is purely a clarity note, keep it mathematical (no Lean tactic talk).
- In `lem:base_change_mate_regroupEquiv`, the `\uses{lem:base_change_regroup_linearEquiv}` references a pure-blueprint helper inlined in Lean. Either annotate it as an inline helper (a brief `% ` comment) or leave as-is — do NOT remove it without confirming nothing else relies on the label.

## Out of scope
- Do NOT touch Seam-3 (`lem:base_change_mate_gstar_transpose`), the affine reduction, or FBC-B blocks.
- Do NOT add `\leanok` to anything (sync_leanok owns it).
- Do NOT alter any existing statement's mathematical content or `\lean{}` pin.

## References
None needed — these five helpers are project-bespoke tactic-decomposition lemmas with no external source. Omit `% SOURCE` lines entirely for them.

## Expected outcome
The chapter gains five new project-bespoke blocks (3 Γ-collapse lemmas + 2 variable-legs lemmas) with accurate `\lean{}` pins and `\uses{}` edges, clearing the FBC coverage debt. `leandag` shows zero isolated nodes and zero `unknown_uses` in the Seam-2 neighbourhood; the concrete `lem:base_change_mate_fstar_reindex` is wired to `lem:base_change_mate_fstar_reindex_legs`.
