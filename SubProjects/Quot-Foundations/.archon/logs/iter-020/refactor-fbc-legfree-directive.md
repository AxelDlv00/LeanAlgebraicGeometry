# Refactor Directive

## Slug
fbc-legfree

## Problem

`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`, Seam 2 (the `fstar`-reindex). The
step-(iii) "mate-unwinding" crux has been unmovable for **6 consecutive iters (014–019)**.
Two independent fresh-context audits this iter (progress-critic `iter020` → STUCK, refactor;
mathlib-analogist `fbc-mate` cross-domain) converge on the SAME root cause:

> **`base_change_mate_codomain_read_legs` (line 1210) is parametrized by the leg-equality
> *proofs* `hfst : g' = …`, `hsnd : f' = …`.** After `subst hfst; subst hsnd` inside
> `base_change_mate_fstar_reindex_legs` (line 1333), the leg `g'` is a *locked literal*
> `(pullbackSpecIso …).hom ≫ Spec.map (CommRingCat.ofHom (includeLeftRingHom …))` that no
> positional `rw [base_change_mate_fstar_reindex_legs_unitExpand]` can re-abstract back to the
> metavariable composite `?a ≫ ?b` (dependent-motive wall). The supporting `Category.assoc` /
> `Functor.map_comp` / `Iso.inv_hom_id_app` rewrites additionally misfire on a spurious
> `X.Modules` instance diamond under elaboration.

The two unit-expansion lemmas `base_change_mate_fstar_reindex_legs_unitExpand` (1273) and
`_gammaDistribute` (1304) were proved sorry-free in iter-019, but they **cannot be wired into
the assembly** because the post-`subst` literal does not unify with their `(?a ≫ ?b)` pattern.
This is not a missing-lemma gap; it is a structural mismatch.

## Mathematical Justification

The mathematics is unchanged and correct (Stacks 02KH flat base change of `R⁰f_*`, affine
case; the mate/Beck–Chevalley calculus for the pull/push pseudofunctor on quasi-coherent
modules). The fix is purely a Lean *restructuring* so that the composite leg is manipulated as
free morphism data rather than reconstructed from an equality proof.

Mathlib's own pull/push pseudofunctor stack (`Scheme.Modules.pullbackComp` /
`pushforwardComp` / `pullback_assoc` in `ModuleCat/Sheaf/PullbackContinuous.lean`, re-exported
through `Sheaf.lean:219/238/257`) **never** parametrizes a coherence object by an equality
proof: every coherence is a function of *free morphism variables*, and the composite is written
explicitly (`φ ≫ (sheafPushforward).map ψ`). That is exactly why Mathlib never hits a leg-lock.
The analogist report `task_results/mathlib-analogist-fbc-mate.md` + the persistent analysis in
`analogies/fbc-mate-legreindex.md` give the full diagnosis and the port recipe. The iter-019
prover report `logs/iter-019/.../FlatBaseChange.md` (also at the in-file note above line 1421)
names the same intervention: "rewrite the `g'`-unit via a `g'`-parametrised lemma BEFORE
`subst`, so `g'` is still a free local and matches syntactically."

The key observation that makes the restructure type-check: the two legs are *definitionally* the
explicit composites
```
g'  =  e.hom ≫ Spec.map inclA        -- e := pullbackSpecIso R A R'
f'  =  e.hom ≫ Spec.map inclR'
```
where `inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom …)` and
`inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight …).toRingHom`. So a codomain
read stated **directly at these explicit composites** carries the SAME object as the current
proof-parametrized `base_change_mate_codomain_read_legs … g' f' hfst hsnd`, and the concrete
Seam-2 statement `base_change_mate_fstar_reindex` (1435), whose legs are `pullback.fst` /
`pullback.snd`, still reduces to it by the existing `exact`-up-to-defeq route (the pullback legs
equal those composites by the `pullbackSpecIso` characterization — this is what the current
`hfst`/`hsnd` witnesses prove, now discharged once at the `exact` site rather than carried as
binders).

## Changes Requested

The intent: **eliminate the equality-proof binders from the inner codomain-read and reindex
lemmas; state them over the explicit composite legs built from free morphism coherences.** Keep
the PUBLIC statement of `base_change_mate_fstar_reindex` (1435) and everything downstream of it
(`base_change_mate_gstar_transpose`, `base_change_mate_section_identity`,
`base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`,
`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) BYTE-FOR-BYTE unchanged
in signature — only its proof body may change (to re-establish the reduction to the restructured
inner lemma).

- File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
  - **(1) Re-cut `base_change_mate_codomain_read_legs` (line 1210)** — drop the
    `(g' f' : …)` morphism binders and the `(_hfst …) (_hsnd …)` proof binders. State the iso
    directly with `g'`/`f'` replaced by the explicit composites `e.hom ≫ Spec.map inclA` and
    `e.hom ≫ Spec.map inclR'` (introduce `e`, `inclA`, `inclR'` as `let`s in the type exactly as
    the body already does at lines 1235–1239). The right-hand object
    (`restrictScalars inclR' (extendScalars inclA M)`) is unchanged. The body is the SAME
    construction (lines 1240–1258) with `g' := e.hom ≫ Spec.map inclA`, `f' := e.hom ≫ Spec.map
    inclR'` substituted and the now-trivial `iso_g`/`pushforwardCongr hsnd` steps simplified
    away (the `pullbackCongr hfst` / `pushforwardCongr hsnd` factors collapse to identities once
    the legs are literally the composites — keep them as `pullbackComp`/`pushforwardComp`
    coherences as in the Mathlib `pullback_assoc` idiom). If any sub-step's proof no longer
    closes after the restructure, leave a `sorry` there (do NOT attempt to prove it) — that is
    the prover's next-iter target.
  - **(2) Re-cut `base_change_mate_fstar_reindex_legs` (line 1333)** — restate it over the
    explicit composite legs (no free `g' f'`, no `hfst hsnd`, no `subst`). Its conclusion equates
    the Γ-read of the mate's `fstar`-unit AT the explicit composite with
    `base_change_mate_inner_value` via the restructured `base_change_mate_codomain_read_legs`. The
    crux that was blocked is now stated where `…_unitExpand a b N` /`…_gammaDistribute` unify on
    the genuine syntactic `(a ≫ b)` — but **do not prove the crux**; insert a single `sorry` for
    the residual telescoping. The two iter-019 lemmas `…_unitExpand`, `…_gammaDistribute` and the
    `gammaMap_pushforward*` collapses must remain available for the prover to chain next iter.
  - **(3) Repair `base_change_mate_fstar_reindex` (1435)** — its public signature is FROZEN;
    only its proof changes: discharge the leg-equalities `hfst`/`hsnd` at this site (the pullback
    legs equal the explicit composites) and `exact`/`refine` onto the restructured
    `base_change_mate_fstar_reindex_legs`. If the reduction does not close cleanly, leave its
    proof as `sorry` (acceptable — the inner crux sorry already gates it).

- File: `AlgebraicJacobian.lean` and any importer — only if a signature genuinely must change.
  The plan agent expects NO public-signature change to ripple here; if one is unavoidable,
  report it explicitly.

## Affected Files

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (all edits here).
- No other file should break (the only restructured decls are the two internal `…_legs` lemmas;
  the public Seam-2 statement is preserved). If `AlgebraicJacobian.lean` or any downstream file
  fails to compile, that signals an unintended public-signature change — STOP and report it
  rather than papering over it.

## Expected Outcome

After the refactor, `lake build AlgebraicJacobian.Cohomology.FlatBaseChange` is GREEN with the
sorry landscape:
- `base_change_mate_codomain_read_legs` — closed if the restructure dissolves all sub-steps;
  otherwise ≤1 `sorry` at the residual coherence step.
- `base_change_mate_fstar_reindex_legs` — exactly ONE `sorry` at the (now-unlocked) step-(iii)
  telescoping crux, stated so that `…_unitExpand`/`…_gammaDistribute` unify syntactically.
- `base_change_mate_fstar_reindex` — `sorry`-free if the reduction closes; otherwise it chains
  the inner sorry.
- The three pre-existing downstream sorries (`base_change_mate_gstar_transpose` ~1525,
  `affineBaseChange_pushforward_iso` ~1698, `flatBaseChange_pushforward_isIso` ~1720) UNCHANGED.

Net: the leg-lock is dissolved — the crux is reachable by syntactic `rw` of the two proved
expansion lemmas — so a fine-grained prover can close it next iter. Do NOT prove the crux
yourself; insert `sorry` and report the exact new goal state at that sorry so the next directive
is precise.
