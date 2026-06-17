# Refactor directive — FBC Seam-2: abstract the pullback legs as substitutable variables

## File (write-domain)
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean` ONLY. Do NOT touch any other `.lean` file.
Build MUST stay green (sorries are allowed; compile errors are not).

## Why (the CHURNING corrective — progress-critic iter-017)
Seam 2 `base_change_mate_fstar_reindex` (theorem, ~line 1166, `sorry` at ~1248) has been blocked for
two consecutive prover iters by a DEPENDENT-TYPE wall, NOT a missing lemma. The leg-reindex engine
`pullbackPushforward_unit_comp` (line ~1140) is proved and axiom-clean, and Seam 1
`base_change_mate_unit_value` is closed; but they cannot be wired in because the two pullback cone legs
`Limits.pullback.fst (Spec.map φ) (Spec.map ψ)` and `Limits.pullback.snd (Spec.map φ) (Spec.map ψ)`
appear in DEPENDENT positions, so `rw [hfst]`/`rw [hsnd]` fail with "motive is not type correct".
The dependent positions are: the adjunction index `pullbackPushforwardAdjunction (pullback.fst …)`;
the proof `(IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w` inside `pushforwardCongr`; the
argument of `gammaPushforwardIso ψ (… pushforward (pullback.snd …) …)`; and — load-bearing — inside
the TYPE of the opaque def `base_change_mate_codomain_read ψ φ M` (line 773), whose statement pins the
literal legs.

The progress-critic's named corrective is a STRUCTURAL REFACTOR: restate the chain (and
`base_change_mate_codomain_read`) with the two legs as ABSTRACT VARIABLE parameters, so the genuine
proof gap lands on a well-typed, substitutable motive. This is the explicit "(i) abstract
variable-legs restatement" step the blueprint chapter now describes for `lem:base_change_mate_fstar_reindex`.

## Structural change to make
1. **Introduce an abstract variable-legs sibling of `base_change_mate_codomain_read`.** Suggested name
   `base_change_mate_codomain_read_of_legs`. It takes the two morphisms as explicit free variables —
   e.g. `(g' f' : <appropriate Scheme hom type>)` standing for the two legs — together with the
   cone-leg equality hypotheses
   `(hg' : g' = e.hom ≫ Spec.map inclA)` and `(hf' : f' = e.hom ≫ Spec.map inclR')`
   (with `e := pullbackSpecIso …`, `inclA`/`inclR'` the tensor inclusions, exactly as the existing
   `codomain_read` proof `set`s them at lines 773–800), and whatever pullback-square coherence the
   chain needs supplied as an explicit hypothesis rather than the literal `IsPullback.of_hasPullback`.
   Its statement is the same iso as `codomain_read` but phrased over `g' f'`. Prove it by
   `subst hg' hf'` (or `cases`) reducing to the affine `Spec(inclA)/Spec(inclR')` case, then reuse the
   existing `codomain_read` proof body. If a residual genuine gap remains, leave a single typed `sorry`
   there — do NOT fill proofs.
2. **Re-derive the concrete `base_change_mate_codomain_read`** as the instantiation of the `_of_legs`
   version at the literal legs with `hg'`/`hf'` = the existing `hfst`/`hsnd`. KEEP its public name and
   signature byte-for-byte (downstream consumers — Seam 3, `section_identity`, `domain_read` — depend
   on it).
3. **Introduce the abstract variable-legs sibling of the Seam-2 chain.** Suggested name
   `base_change_mate_fstar_reindex_of_legs`: the same equation as `base_change_mate_fstar_reindex` but
   with the legs as variables `g' f'` (+ `hg'`/`hf'`) and using `base_change_mate_codomain_read_of_legs`
   in its codomain. Its body should `subst hg' hf'` so that, on the substituted goal, the legs are the
   affine `Spec(inclA)`/`Spec(inclR')` maps and `pullbackPushforward_unit_comp` + Seam 1
   `base_change_mate_unit_value` + the transparent Γ-collapse (`pushforwardComp_*_app_app = 𝟙`,
   `pushforwardCongr_hom_app_app = eqToHom`) are now APPLICABLE by `rw` without the motive error.
   Leave the genuine remaining proof gap as a single typed `sorry` (do NOT fill).
4. **Re-derive `base_change_mate_fstar_reindex`** (KEEP its public name + signature) as the
   instantiation of `_of_legs` at the literal legs with `hfst`/`hsnd`.

## Hard constraints
- KEEP every PUBLIC declaration's name + signature unchanged: `base_change_mate_codomain_read`,
  `base_change_mate_fstar_reindex`, `base_change_mate_inner_value`, `base_change_mate_gstar_transpose`,
  `pullbackPushforward_unit_comp`, and all downstream lemmas. The `_of_legs` versions are NEW additions.
- `archon-protected.yaml` is empty, so adding decls is fine; but do not rename/delete existing ones.
- Insert `sorry` ONLY at the genuine remaining proof gap(s). Never fill a proof. The whole file must
  `lake build` green (sorries OK). If a step cannot be made to compile, STOP and report rather than
  leaving the build broken.
- The single objective is to convert the dependent-position legs into substitutable variables so the
  iter-018 prover can close Seam 2 by `subst` + the already-proved engine. Partial success =
  `base_change_mate_codomain_read_of_legs` landed and compiling with the legs abstracted, even if the
  Seam-2 `_of_legs` chain still carries a sorry.

## Report (required)
List every NEW declaration you add with its EXACT final name + full signature, and which existing
proof sites you re-derived. The plan agent needs these names to author matching blueprint blocks
(Lean↔blueprint 1:1).
