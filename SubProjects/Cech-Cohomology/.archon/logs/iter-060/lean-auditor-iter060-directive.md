# Lean Auditor Directive

## Slug
iter060

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to the two files edited this iteration:
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

In CechSectionIdentification.lean, the newly-built declarations are
`widePullbackBaseCongr`, `coverInterProdIso`, `cechBackbone_left_sigma`
(a universe-reduction `Fin n` reindexing assembly). Verify the `cechBackbone_left_sigma`
proof is a genuine geometric backbone identification, not a Subsingleton/defeq launder, and
that the four remaining `sorry`-bodied decls (`pushPull_sigma_iso`, `pushPull_eval_prod_iso`,
`cechSection_complex_iso`, `cechSection_contractible`) carry honest holes with correctly-typed
goals.

In OpenImmersionPushforward.lean, the newly-built declarations are `sectionsCorep`,
`sectionsCorepPushforward`, `jShriekOU_transport_along_iso`. Verify the
`jShriekOU_transport_along_iso` corepresentability construction is genuine (both sides corepresent
the same functor), and that the `case hqc => sorry` inside `higherDirectImage_openImmersion_acyclic`
and the `sorry` in `higherDirectImage_openImmersion_comp` are honest holes, not papering. Check for
any excuse-comments.

## Known issues
- `CechAcyclic.lean:110` (`AlgebraicGeometry.CechAcyclic.affine`) is a known DEAD declaration
  (superseded route); its `sorry` is intentional and already documented. Do not re-flag as new.
- `CechHigherDirectImage.lean:780` is a frozen P5b-assembly sorry awaiting upstream completion.
- The four CSI `sorry`-bodied decls and the two OpenImm `sorry` holes are known, intentional
  frontier holes — flag only if their *type/goal* is wrong or papered, not their mere existence.

## Absolute paths
Read all `.lean` files under `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/`.
